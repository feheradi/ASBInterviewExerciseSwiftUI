//
//  RestClientMock.swift
//  ASBInterviewExerciseSwiftUITests
//
//  Created by Adam Feher on 2022. 07. 01..
//

import Foundation
@testable import ASBInterviewExerciseSwiftUI

class RestClientMock: RestClient {
    var data: Data?
    var error: NSError?
    
    init(data: Data?, error: NSError?) {
        super.init()
        self.data = data
        self.error = error
    }
    
    override func apiRequest(_ url: URL) async throws -> (Data, URLResponse) {
        if let error = error {
            throw error
        } else {
            return (data!, URLResponse())
        }
    }
}
