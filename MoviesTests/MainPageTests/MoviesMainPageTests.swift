//
//  MoviesMainPageTests.swift
//  MoviesTests
//
//  Created by Ayşenur Bakırcı on 11.10.2021.
//

import XCTest
import RxSwift
import RxTest
import RxBlocking
@testable import Movies

class MoviesMainPageTests: XCTestCase {
    
    var sut: MainViewModel!
    var scheduler: TestScheduler!
    var disposeBag: DisposeBag!

    override func setUpWithError() throws {
        super.setUp()
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
        sut = MainViewModel(mainViewService: MockMainApi())
    }

    override func tearDownWithError() throws {
        sut = nil
        disposeBag = nil
        scheduler = nil
        super.tearDown()
    }
    
    func testNumberOfPages() throws {
        let nextPage = scheduler.createObserver(Int.self)
        
        sut.nextPage
            .bind(to: nextPage)
            .disposed(by: disposeBag)
        
        scheduler.createColdObservable([.next(10, ()), .next(50, ())])
            .bind(to: sut.loadData)
            .disposed(by: disposeBag)
        
        scheduler.start()
        XCTAssertEqual(nextPage.events, [.next(0, 1), .next(10, 2), .next(50, 3)])
    }
    
    func testPopularMovieLoading() throws {
        let loading = scheduler.createObserver(Bool.self)
        
        sut.isLoading
            .bind(to: loading)
            .disposed(by: disposeBag)
        
        scheduler.createColdObservable([.next(10, ())])
            .bind(to: sut.loadData)
            .disposed(by: disposeBag)
        
        scheduler.start()
        XCTAssertEqual(loading.events, [.next(0, false), .next(10, true)])
    }
    
    func testFirstPopularMovieName() throws {
        
        guard let data = try sut?.data.toBlocking().first() else { return }
        switch data.first {
        case .movie(let movies):
            XCTAssertEqual(movies.first?.title, "Venom: Let There Be Carnage")
        case .person(_):
            XCTFail("Popular movie does not include person.")
        case .none:
            XCTFail("Data is empty.")
        }
    }
    
    func testSearchLoading() throws {
        let loading = scheduler.createObserver(Bool.self)
        
        sut.isLoading
            .asDriver()
            .drive(loading)
            .disposed(by: disposeBag)
        
        scheduler.createColdObservable([.next(10, "witcher")])
            .bind(to: sut.searchQuery)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        XCTAssertEqual(loading.events, [.next(0, false), .next(10, true)])
    }
    
    func testSearch() throws {
        
        guard let data = try sut?.data.toBlocking().first() else { return }
        switch data.first {
        case .movie(let movies):
            XCTAssertEqual(movies.first?.title, "The Witcher: Nightmare of the Wolf")
        case .person(let people):
            XCTAssertEqual(people.first?.name, "Jeff Witcher")
        case .none:
            XCTFail("Data is empty.")
        }
    }
    
}
