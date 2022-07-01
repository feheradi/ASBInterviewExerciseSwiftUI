//
//  DetailView.swift
//  ASBInterviewExerciseSwiftUI
//
//  Created by Adam Feher on 2022. 07. 01..
//

import SwiftUI

struct DetailView: View {
    var txn: Transaction
    var viewModel: ViewModel
    
    var body: some View {
        Form {
            Section(viewModel.s_ID) {
                Text(String(txn.id))
            }
            
            Section(viewModel.s_Summary) {
                Text(txn.summary)
            }
            
            Section(viewModel.s_TxnDate) {
                Text(txn.transactionDate)
            }
                        
            Section(viewModel.s_Amount) {
                let details = viewModel.getDetails(for: txn)
                
                HStack {
                    Text(details.type)
                    Spacer()
                    Text("\(details.amount, specifier: "%.2f")")
                }.foregroundColor(details.color)
                
                HStack {
                    Text(viewModel.s_GST)
                    Spacer()
                    Text("\(details.gst, specifier: "%.2f")")
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}
