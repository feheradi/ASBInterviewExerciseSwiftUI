//
//  MainView.swift
//  ASBInterviewExerciseSwiftUI
//
//  Created by Adam Feher on 2022. 07. 01..
//

import SwiftUI

struct MainView: View {
    @StateObject var viewModel: ViewModel
    
    var body: some View {
        NavigationView {
            List(viewModel.transactions, id: \.id) { txn in
                NavigationLink {
                    DetailView(txn: txn, viewModel: viewModel)
                } label: {
                    ListRowView(txn: txn)
                }
            }
            .navigationTitle(viewModel.s_NavTitle)
            .onAppear {
                viewModel.onAppear()
            }
        }
    }
}
