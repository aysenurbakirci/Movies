//
//  MoviesMainPageTests.swift
//  MoviesTests
//
//  Created by Ayşenur Bakırcı on 11.10.2021.
//

import XCTest
import RxSwift
import RxTest
@testable import Movies

class MoviesMainPageTests: XCTestCase {
    
    var sut: MainViewModel!
    var scheduler: TestScheduler!
    var disposeBag: DisposeBag!
    
    override func setUpWithError() throws {
        super.setUp()
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
        sut = MainViewModel(mainViewService: MockMainApi(scheduler: scheduler))
    }
    
    override func tearDownWithError() throws {
        sut = nil
        disposeBag = nil
        scheduler = nil
        super.tearDown()
    }
    
    func testNumberOfPages() throws {
        
        scheduler.createColdObservable([.next(0, ()), .next(100, ())])
            .bind(to: sut.loadData)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        XCTAssertEqual(sut.nextPage, 3)
    }
    
    func testLoadingWithPopularMovies() throws {
        let loading = scheduler.createObserver(Bool.self)
        
        sut.isLoading
            .bind(to: loading)
            .disposed(by: disposeBag)
        
        scheduler.createColdObservable([.next(0, ()), .next(100, ())])
            .bind(to: sut.loadData)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        XCTAssertEqual(loading.events, [.next(0, false), .next(0, true), .next(10, false), .next(100, true), .next(110, false)])
    }
    
    func testLoadingErrorWithPopularMovies() throws {
        
        enum CustomError: String, Error {
            case somethingBadHappened
        }
        
        let loading = scheduler.createObserver(Bool.self)
        
        sut.isLoading
            .bind(to: loading)
            .disposed(by: disposeBag)
        
        scheduler.createColdObservable([.next(10, ()), .error(50, (CustomError.somethingBadHappened))])
            .bind(to: sut.loadData)
            .disposed(by: disposeBag)
        
        scheduler.start()
        XCTAssertEqual(loading.events, [.next(0, false), .next(10, true), .next(20, false), .next(50, false)])
    }
    
    func testLoadingWithSearch() throws {
        let loading = scheduler.createObserver(Bool.self)
        
        sut.isLoading
            .bind(to: loading)
            .disposed(by: disposeBag)
        
        scheduler.createColdObservable([.next(50, "witcher")])
            .bind(to: sut.searchQuery)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        XCTAssertEqual(loading.events, [.next(0, false), .next(50, true), .next(55, false)])
    }
    
//    func testLoadingErrorWithSearch() throws {
//        
//        enum CustomError: String, Error {
//            case somethingBadHappened
//        }
//        
//        let loading = scheduler.createObserver(Bool.self)
//        
//        sut.isLoading
//            .bind(to: loading)
//            .disposed(by: disposeBag)
//        
//        scheduler.createColdObservable([.next(50, "witcher"), .error(80, CustomError.somethingBadHappened)])
//            .bind(to: sut.searchQuery)
//            .disposed(by: disposeBag)
//        
//        scheduler.start()
//        XCTAssertEqual(loading.events, [.next(0, false), .next(50, true), .next(55, false), .next(50, false), .next(80, false)])
//    }
    
    func testFirstPopularMovieName() throws {
        
        guard let data = try sut?.data.toBlocking().first() else { return }
        switch data.first {
        case .movie(let movies):
            XCTAssertEqual(movies.first?.title, "Venom: Let There Be Carnage")
        case .person(_):
            XCTFail("Popular movie does not include person.")
        case .none:
            print("empty")
        }
    }
    
    func testFirstSearchResults() throws {
        
        guard let data = try sut.data.toBlocking().first() else { return }
        switch data.first {
        case .movie(let movies):
            XCTAssertEqual(movies.first?.title, "The Witcher: Nightmare of the Wolf")
        case .person(let people):
            XCTAssertEqual(people.first?.name, "Jeff Witcher")
        case .none:
            print("empty")
        }
    }
}
