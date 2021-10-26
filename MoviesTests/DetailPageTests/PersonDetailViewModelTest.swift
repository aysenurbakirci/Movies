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
    var scheduler: TestScheduler!
    var disposeBag: DisposeBag!

    override func setUpWithError() throws {
        super.setUp()
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
        sut = PersonDetailViewModel(personId: 2535, service: MockDetailApi())
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
            .disposed(by: disposeBag)
    }
    
    func testGetPersonMovies() throws {
        sut?.data
            .subscribe(onNext: { data in
                XCTAssertEqual(data?.castArray.first?.title, "Two Can Play That Game")
                XCTAssertNotEqual(data?.castArray.first?.title, "Two")
            })
            .disposed(by: disposeBag)
    }
}
