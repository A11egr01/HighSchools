//
//  HightSchoolsTests.swift
//  HightSchoolsTests
//
//  Created by Allegro on 10/25/23.
//

import XCTest
@testable import HightSchools
import Combine

final class HightSchoolsTests: XCTestCase {
    var viewModel: HighSchoolViewModel!
    var dataService: MockDataService!
    
    override func setUp() {
        super.setUp()
        
        dataService = MockDataService()
        viewModel = HighSchoolViewModel(dataService: dataService)
    }
    
    override func tearDown() {
        viewModel = nil
        dataService = nil
        super.tearDown()
    }
    
    // MARK: - MockDataService
    
    class MockDataService: DataService {
        func fetchHighSchools() -> AnyPublisher<[HighSchool], Error> {
            // Simulate fetching high school data
            let highSchools: [HighSchool] = [HighSchool(dbn: "123", school_name: "Test School", location: "LA", phone_number: "888", website: "Hello", state_code: "NY", city: "NYC")]
            return Just(highSchools)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        
        func fetchSATScores() -> AnyPublisher<[SatScores], Error> {
            // Simulate fetching SAT scores
            let satScores: [SatScores] = [SatScores(dbn: "456", school_name: "Test school 2", num_of_sat_test_takers: "30", sat_critical_reading_avg_score: "400", sat_math_avg_score: "500", sat_writing_avg_score: "600")]
            return Just(satScores)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }
    
    // MARK: - Test Cases
    
    func testFetchHighSchools() {
        let expectation = XCTestExpectation(description: "High Schools Fetched")
        
        viewModel.fetchHighSchools()
            .sink(receiveCompletion: { _ in }, receiveValue: { highSchools in
                XCTAssertEqual(highSchools.count, 1) // Using 1 for testing
                expectation.fulfill()
            })
            .store(in: &viewModel.cancellables)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testFetchSATScores() {
        let expectation = XCTestExpectation(description: "SAT Scores Fetched")
        
        viewModel.fetchSATScores()
            .sink(receiveCompletion: { _ in }, receiveValue: { satScores in
                XCTAssertEqual(satScores.count, 1) // Using 1 for testing
                expectation.fulfill()
            })
            .store(in: &viewModel.cancellables)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testGetCountOfHighSchools() {
        let expectation = XCTestExpectation(description: "High Schools Count Retrieved")
        
        viewModel.getCountOfHighSchools()
            .sink(receiveCompletion: { _ in }, receiveValue: { count in
                XCTAssertEqual(count, 1) // Using 1 for testing 
                expectation.fulfill()
            })
            .store(in: &viewModel.cancellables)
        
        wait(for: [expectation], timeout: 1)
    }
}
