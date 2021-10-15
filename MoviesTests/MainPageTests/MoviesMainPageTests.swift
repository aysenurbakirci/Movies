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
    
    var sut: MainViewModel?
    let scheduler = ConcurrentDispatchQueueScheduler(qos: .default)

    override func setUpWithError() throws {
        super.setUp()
        sut = MainViewModel(mainViewService: MockMainApi())
    }

    override func tearDownWithError() throws {
        sut = nil
        super.tearDown()
    }
    
    func testMovieObservableIsNotNill() throws {
        let movieObservable = sut?.getPopularMovies(nextPage: 1).subscribe(on: scheduler)
        XCTAssertNotNil(try movieObservable?.toBlocking().first(), "Observable must not be nil")
    }
    
    func testDataPageNumber() throws {
        let movieObservable = sut?.getPopularMovies(nextPage: 1).subscribe(on: scheduler)
        
        guard let result = try movieObservable?.toBlocking().first()?.page else {
            XCTFail()
            fatalError()
        }
        XCTAssertNotEqual(result, 2, "Page number should be 1")
        XCTAssertEqual(result, 1, "Page number should be 1")
    }
    
    func testFirstMovieName() throws {
        let movieObservable = sut?.getPopularMovies(nextPage: 1).subscribe(on: scheduler)
        
        guard let result = try movieObservable?.toBlocking().first()?.results else {
            XCTFail()
            fatalError()
        }
        XCTAssertNotEqual(result.first?.title, "dummy", "The title of the first movie should be -> Venom: Let There Be Carnage")
        XCTAssertEqual(result.first?.title, "Venom: Let There Be Carnage", "The title of the first movie should be -> Venom: Let There Be Carnage")
    }
}
