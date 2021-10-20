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
    
    var sut: MovieDetailViewModel?
    let scheduler = ConcurrentDispatchQueueScheduler(qos: .default)

    override func setUpWithError() throws {
        super.setUp()
        sut = MovieDetailViewModel(movieId: 839436, service: MockDetailApi())
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
    
    func testGetMovieName() throws {
        sut?.data
            .subscribe(onNext: { data in
                XCTAssertEqual(data?.title, "Dragon Fury")
                XCTAssertNotEqual(data?.title, "Dragon")
            })
            .dispose()
    }
    
    func testGetMovieCast() throws {
        sut?.data
            .subscribe(onNext: { data in
                XCTAssertEqual(data?.castArray.first?.title, "Nicola Wright")
                XCTAssertNotEqual(data?.castArray.first?.title, "Nicola")
            })
            .dispose()
    }
    
    func testGetMovieTrailer() throws {
        sut?.data
            .subscribe(onNext: { data in
                XCTAssertEqual(data?.link, "kp_iCBrjeKA")
                XCTAssertNotEqual(data?.link, "A")
            })
            .dispose()
    }

}
