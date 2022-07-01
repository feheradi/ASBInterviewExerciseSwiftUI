//
//  ASBInterviewExerciseSwiftUIApp.swift
//  ASBInterviewExerciseSwiftUI
//
//  Created by Adam Feher on 2022. 07. 01..
//

import SwiftUI

@main
struct ASBInterviewExerciseSwiftUIApp: App {
    let restClient = RestClient()
    
    var body: some Scene {
        WindowGroup {
            MainView(viewModel: ViewModel(restClient: restClient))
        }
    }
}
