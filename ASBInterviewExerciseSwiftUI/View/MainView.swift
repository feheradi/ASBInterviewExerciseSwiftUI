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
            List {
                ForEach(viewModel.transactions.sorted(by: { $0.0 > $1.0 }), id: \.key) { key, value in
                    Section(header: Text(viewModel.formatDate(for: key, dateFormat: .justDate))) {
                        ForEach(value, id: \.self) { txn in
                            NavigationLink {
                                DetailView(txn: txn, viewModel: viewModel)
                            } label: {
                                ListRowView(txn: txn, viewModel: viewModel)
                            }
                        }
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle(viewModel.s_NavTitle)
            .onAppear {
                viewModel.onAppear()
            }
            .alert(isPresented: $viewModel.showAlert) {
                Alert(title: Text(viewModel.s_Error_Title), message: Text(viewModel.alertMessage))
            }
            .refreshable {
                viewModel.refresh()
            }
        }
    }
}
