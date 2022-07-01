//
//  ViewModel.swift
//  ASBInterviewExerciseSwiftUI
//
//  Created by Adam Feher on 2022. 07. 01..
//

import Foundation

@MainActor class ViewModel: ObservableObject {
    let restClient: RestClient
    
    init(restClient: RestClient) {
        self.restClient = restClient
    }
    
    @Published var transactions = [Transaction]()
    
    func onAppear() {
        getData()
    }
    
    // MARK: - Private properties & functions
    private let url = URL(string: "https://gist.githubusercontent.com/Josh-Ng/500f2716604dc1e8e2a3c6d31ad01830/raw/4d73acaa7caa1167676445c922835554c5572e82/test-data.json")!
    
    private func getData() {
        Task.init {
            do {
                let (data, _) = try await restClient.apiRequest(url)
                parse(data)
            } catch {
                // TODO: - Handle error
                print(error)
            }
        }
    }
    
    private func parse(_ data: Data) {
        guard let txns = try? JSONDecoder().decode([Transaction].self, from: data) else {
            // TODO: - Handle error
            return
        }
        transactions = txns
    }
}
