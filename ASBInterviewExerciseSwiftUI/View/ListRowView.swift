//
//  ListRowView.swift
//  ASBInterviewExerciseSwiftUI
//
//  Created by Adam Feher on 2022. 07. 01..
//

import SwiftUI

struct ListRowView: View {
    let txn: Transaction
    let viewModel: ViewModel
    
    var body: some View {
        let details = viewModel.getDetails(for: txn)
        
        VStack {
            Text(txn.summary)
            HStack {
                Text(txn.transactionDate)
                Text("\(details.amount, specifier: "%.2f")")
                    .foregroundColor(details.color)
            }
        }
    }
}
