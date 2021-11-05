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
    
    func testFirstPopularMovieName() throws {
        
        let popularMovies = scheduler.createObserver([Section].self)
        
        sut.data
            .bind(to: popularMovies)
            .disposed(by: disposeBag)
        
        scheduler.createColdObservable([.next(10, ())])
            .bind(to: sut.loadData)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        XCTAssertFalse(popularMovies.events.isEmpty)
    }
    
    func testFirstSearchResults() throws {
        
        let searchResults = scheduler.createObserver([Section].self)
        
        sut.data
            .bind(to: searchResults)
            .disposed(by: disposeBag)
        
        scheduler.createColdObservable([.next(50, "witcher")])
            .bind(to: sut.searchQuery)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        XCTAssertFalse(searchResults.events.isEmpty)
    }
}
