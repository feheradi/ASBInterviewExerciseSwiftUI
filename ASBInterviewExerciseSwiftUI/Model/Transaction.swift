//
//  Transaction.swift
//  ASBInterviewExerciseSwiftUI
//
//  Created by Adam Feher on 2022. 07. 01..
//

import Foundation

struct Transaction: Codable, Hashable {
    let id: Int
    let transactionDate: String
    let summary: String
    let debit: Double
    let credit: Double
}
