//
//  PersonDetailViewModelTest.swift
//  MoviesTests
//
//  Created by Ayşenur Bakırcı on 20.10.2021.
//

import XCTest
import RxSwift
import RxTest
import RxBlocking
@testable import Movies

class PersonDetailViewModelTest: XCTestCase {
    
    var sut: PersonDetailViewModel?
    let scheduler = ConcurrentDispatchQueueScheduler(qos: .default)

    override func setUpWithError() throws {
        super.setUp()
        sut = PersonDetailViewModel(personId: 2535, service: MockDetailApi())
        sut?.loadData.onNext(())
    }

    override func tearDownWithError() throws {
        sut = nil
        super.tearDown()
    }
    
    func testMovieObservableIsNotNill() throws {
        let movieObservable = sut?.data.asObservable()
        let result = try movieObservable?.toBlocking().first()
        XCTAssertNotNil(result!, "Observable must not be nil")
    }
    
    func testGetPersonName() throws {
        sut?.data
            .subscribe(onNext: { data in
                XCTAssertEqual(data?.title, "Vivica A. Fox")
                XCTAssertNotEqual(data?.title, "Vivica")
            })
            .dispose()
    }
    
    func testGetPersonMovies() throws {
        sut?.data
            .subscribe(onNext: { data in
                XCTAssertEqual(data?.castArray.first?.title, "Two Can Play That Game")
                XCTAssertNotEqual(data?.castArray.first?.title, "Two")
            })
            .dispose()
    }
}
