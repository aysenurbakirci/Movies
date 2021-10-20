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
        sut?.loadData.onNext(())
    }

    override func tearDownWithError() throws {
        sut = nil
        super.tearDown()
    }
    
    func testFirstMovieName() throws {
        sut?.data
            .subscribe(onNext: { section in
                XCTAssertNotNil(section, "Observable must not be nil")
            })
            .dispose()
    }
}
