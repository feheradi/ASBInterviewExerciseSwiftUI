//
//  ASBInterviewExerciseSwiftUITests.swift
//  ASBInterviewExerciseSwiftUITests
//
//  Created by Adam Feher on 2022. 07. 01..
//

import XCTest
import SwiftUI
@testable import ASBInterviewExerciseSwiftUI

@MainActor class ASBInterviewExerciseSwiftUITests: XCTestCase {

    private var viewModel: ViewModel!
    
    let mockData = [
        Transaction(id: 1,
                    transactionDate: "2021-08-31T15:47:10",
                    summary: "Hackett, Stamm and Kuhn",
                    debit: 9379.55,
                    credit: 0),
        Transaction(id: 2,
                    transactionDate: "2022-02-17T10:44:35",
                    summary: "Hettinger, Wilkinson and Kshlerin",
                    debit: 3461.35,
                    credit: 0),
        Transaction(id: 3,
                    transactionDate: "2021-02-21T08:19:12",
                    summary: "McKenzie, Bins and Macejkovic",
                    debit: 0,
                    credit: 1415.74),
        Transaction(id: 85,
                    transactionDate: "2022-02-17T07:32:40",
                    summary: "Wiza, Gleichner and Cummerata",
                    debit: 5899.4,
                    credit: 0)
    ]
    
    let sortedMockData = [
        "2021-02-21":
            [Transaction(id: 3,
                         transactionDate: "2021-02-21T08:19:12",
                         summary: "McKenzie, Bins and Macejkovic",
                         debit: 0.0,
                         credit: 1415.74)],
         "2022-02-17":
            [Transaction(id: 2,
                         transactionDate: "2022-02-17T10:44:35",
                         summary: "Hettinger, Wilkinson and Kshlerin",
                         debit: 3461.35,
                         credit: 0.0),
             Transaction(id: 85,
                          transactionDate: "2022-02-17T07:32:40",
                          summary: "Wiza, Gleichner and Cummerata",
                          debit: 5899.4,
                          credit: 0.0)],
         "2021-08-31":
            [Transaction(id: 1,
                         transactionDate: "2021-08-31T15:47:10",
                         summary: "Hackett, Stamm and Kuhn",
                         debit: 9379.55,
                         credit: 0.0)]
    ]
    
    func testDateFormatting() {
        viewModel = ViewModel(restClient: RestClientMock(data: nil, error: nil))
        let expectation = XCTestExpectation()
        let str = self.mockData[0].transactionDate
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(self.viewModel.formatDate(for: str, dateFormat: .long), "31 August 2021 at 3:47 PM")
            XCTAssertEqual(self.viewModel.formatDate(for: str, dateFormat: .justTime), "3:47 PM")
            XCTAssertEqual(self.viewModel.formatDate(for: String(str.prefix(10)), dateFormat: .justDate), "31 August 2021")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
    
    func testDetailsForDebit() {
        viewModel = ViewModel(restClient: RestClientMock(data: nil, error: nil))
        let expectation = XCTestExpectation()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let details = self.viewModel.getDetails(for: self.mockData[0])
            XCTAssertEqual(details.amount, 9379.55)
            XCTAssertEqual(details.gst, 1406.9325)
            XCTAssertEqual(details.type, "Debit")
            XCTAssertEqual(details.color, Color.red)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
    
    func testDetailsForCredit() {
        viewModel = ViewModel(restClient: RestClientMock(data: nil, error: nil))
        let expectation = XCTestExpectation()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let details = self.viewModel.getDetails(for: self.mockData[2])
            XCTAssertEqual(details.amount, 1415.74)
            XCTAssertEqual(details.gst, 212.361)
            XCTAssertEqual(details.type, "Credit")
            XCTAssertEqual(details.color, Color.green)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
    
    func testDataDownloadOnAppear() {
        let data = try? JSONEncoder().encode(mockData)
        viewModel = ViewModel(restClient: RestClientMock(data: data, error: nil))
        viewModel.onAppear()
        let expectation = XCTestExpectation()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(self.viewModel.alertMessage, "")
            XCTAssertFalse(self.viewModel.showAlert)
            XCTAssertEqual(self.viewModel.transactions, self.sortedMockData)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
    
    func testDataDownloadOnRefresh() {
        let data = try? JSONEncoder().encode(mockData)
        viewModel = ViewModel(restClient: RestClientMock(data: data, error: nil))
        viewModel.refresh()
        let expectation = XCTestExpectation()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(self.viewModel.alertMessage, "")
            XCTAssertFalse(self.viewModel.showAlert)
            XCTAssertEqual(self.viewModel.transactions, self.sortedMockData)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
    
    func testApiRequestError() {
        let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "error"])
        viewModel = ViewModel(restClient: RestClientMock(data: nil, error: error))
        viewModel.onAppear()
        let expectation = XCTestExpectation()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(self.viewModel.alertMessage, "error")
            XCTAssertTrue(self.viewModel.showAlert)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
    
    func testParsingError() {
        let data = Data("NoData".utf8)
        viewModel = ViewModel(restClient: RestClientMock(data: data, error: nil))
        viewModel.onAppear()
        let expectation = XCTestExpectation()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(self.viewModel.alertMessage, "Could not parse the data.")
            XCTAssertTrue(self.viewModel.showAlert)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
}
