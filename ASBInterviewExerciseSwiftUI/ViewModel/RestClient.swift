//
//  RestClient.swift
//  ASBInterviewExerciseSwiftUI
//
//  Created by Adam Feher on 2022. 07. 01..
//

import Foundation

class RestClient {
        
    var session: URLSession
    
    init() {
        session = URLSession(configuration: .default)
    }
        
    func apiRequest(_ url: URL) async throws -> (Data, URLResponse) {
        try await session.data(from: url)
    }
}
