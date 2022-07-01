//
//  Transaction.swift
//  ASBInterviewExerciseSwiftUI
//
//  Created by Adam Feher on 2022. 07. 01..
//

import Foundation

struct Transaction: Codable {
    var id: Int
    var transactionDate: String
    var summary: String
    var debit: Double
    var credit: Double
}
