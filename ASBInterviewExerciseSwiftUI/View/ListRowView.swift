//
//  ListRowView.swift
//  ASBInterviewExerciseSwiftUI
//
//  Created by Adam Feher on 2022. 07. 01..
//

import SwiftUI

struct ListRowView: View {
    let txn: Transaction
    
    var body: some View {
        VStack {
            Text(txn.summary)
            HStack {
                Text(txn.transactionDate)
                Text("\(txn.credit)").foregroundColor(.green)
                Text("\(txn.debit)").foregroundColor(.red)
            }
        }
    }
}
