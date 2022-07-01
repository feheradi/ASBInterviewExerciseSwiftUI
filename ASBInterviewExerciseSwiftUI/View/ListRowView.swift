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
        let txnTime = viewModel.formatDate(for: txn.transactionDate, dateFormat: .justTime)
        
        HStack {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: 60, height: 40)
                    .foregroundColor(Color("BgColor"))
                Text(txnTime)
                    .font(.caption)
            }.padding(.trailing, 5)
            
            Text(txn.summary)
            
            Spacer()
            
            Text("\(details.amount, specifier: "%.2f")")
                .foregroundColor(details.color)
                .fontWeight(.semibold)
        }.padding(.vertical, 5)
    }
}
