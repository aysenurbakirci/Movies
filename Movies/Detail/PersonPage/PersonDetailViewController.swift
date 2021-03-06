//
//  PersonDetailViewController.swift
//  Movies
//
//  Created by Ayşenur Bakırcı on 17.10.2021.
//

import UIKit
import RxSwift
import RxCocoa
import Utils
import Components

class PersonDetailViewController: UIViewController, LoadingDisplay, ErrorDisplayer {

    //MARK: - Properties
    private lazy var detailView: PersonDetailView = {
        var view = PersonDetailView()
        view.tableView.delegate = self
        view.tableView.dataSource = self
        return view
    }()
    
    private var personId: Int
    private var loadData = BehaviorRelay<Void>(value: ())
    private var data = BehaviorRelay<[PersonViewSections]>(value: [])
    
    private let disposeBag = DisposeBag()
    
    //MARK: - Initalization
    init(personId: Int) {
        self.personId = personId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Bindings
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = detailView
        clearNavigationBarConfig()
        
        let inputs = PersonDetailViewModelInput(personId: personId,
                                                detailService: DetailApi(),
                                                loadDataTrigger: loadData)
        
        let output = personDetailViewModel(input: inputs)
        
        output
            .data
            .do(onNext: { [weak self] person in
                guard let self = self else { return }
                self.data.accept(person)
            })
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.detailView.tableView.reloadData()
            })
            .disposed(by: disposeBag)
        
        output
            .isLoading
            .drive(onNext: { [weak self] isLoading in
                guard let self = self else { return }
                if isLoading {
                    self.showLoadingView()
                } else {
                    self.hideLoadingView()
                }
            })
            .disposed(by: disposeBag)
        
        output
            .onError
            .drive(onNext: { [weak self] error in
                self?.errorObject.onNext(error)
            })
            .disposed(by: disposeBag)
        
        loadData.accept(())
    }
    
    private func clearNavigationBarConfig() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension PersonDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.value.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = data.value[indexPath.section]
        
        switch section {
        case .detail(let personDetail):
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: InformationCell.reuseIdentifier,
                                                           for: indexPath) as? InformationCell else {
                return UITableViewCell()
            }
            
            cell.apply(personDetail: personDetail)
            detailView.header.apply(imagePath: personDetail.profilePath ?? "")
            
            return cell
            
        case .list(let personMovies):
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ListCell.reuseIdentifier,
                                                           for: indexPath) as? ListCell else {
                return UITableViewCell()
            }
            
            let listModel = ListModel(personMovies: personMovies)
            cell.horizontalListView.dataArrayRelay.accept(listModel.castArray)
            cell.horizontalListView
                .selectedItemId
                .subscribe(onNext: { [weak self] id in
                    guard let self = self else { return }
                    let controller = MovieDetailPageBuilder.build(with: id)
                    self.navigationController?.pushViewController(controller, animated: true)
                })
                .disposed(by: cell.disposeBag)
            
            return cell
        }
    }
}

//MARK: UIScrollViewDelegate
extension PersonDetailViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let header = detailView.tableView.tableHeaderView as? StrechyHeader else { return }
        header.scrollViewDidScroll(scrollView: detailView.tableView)
    }
}
