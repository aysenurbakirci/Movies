//
//  MovieDetailViewModelTest.swift
//  MoviesTests
//
//  Created by Ayşenur Bakırcı on 20.10.2021.
//

import XCTest
import RxSwift
import RxTest
import RxBlocking
@testable import Movies

class MovieDetailViewModelTest: XCTestCase {
    
    var sut: MovieDetailViewModel!
    var scheduler: TestScheduler!
    var disposeBag: DisposeBag!

    override func setUpWithError() throws {
        super.setUp()
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
        sut = MovieDetailViewModel(movieId: 839436, service: MockDetailApi())
        sut?.getDetails()
    }

    override func tearDownWithError() throws {
        sut = nil
        disposeBag = nil
        scheduler = nil
        super.tearDown()
    }
    
    func testMovieObservableIsNotNill() throws {
        let movieObservable = sut?.data.asObservable()
        let result = try movieObservable?.toBlocking().first()
        XCTAssertNotNil(result!, "Observable must not be nil")
    }
}
