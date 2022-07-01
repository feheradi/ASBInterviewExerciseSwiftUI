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
    
    @Published var transactions = [String: [Transaction]]()
    
    func onAppear() {
        getData()
    }
    
    func getDetails(for txn: Transaction) -> TransactionDetail {        
        let credit = TransactionDetail(amount: txn.credit, gst: txn.credit * 0.15, type: s_Credit, color: .green)
        let debit = TransactionDetail(amount: txn.debit, gst: txn.debit * 0.15, type: s_Debit, color: .red)
        return txn.debit != 0 ? debit : credit
    }
    
    enum DateFormat {
        case long
        case justTime
        case justDate
    }
    
    func formatDate(for str: String, dateFormat: DateFormat) -> String {
        let dateFormatter = DateFormatter()
        switch dateFormat {
        case .long, .justTime:
            dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss"
        case .justDate:
            dateFormatter.dateFormat = "yyyy'-'MM'-'dd"
        }
        if let date = dateFormatter.date(from: str) {
            dateFormatter.locale = Locale(identifier: "en_NZ")
            switch dateFormat {
            case .long:
                dateFormatter.dateStyle = .long
                dateFormatter.timeStyle = .short
            case .justTime:
                dateFormatter.dateStyle = .none
                dateFormatter.timeStyle = .short
            case .justDate:
                dateFormatter.dateStyle = .long
                dateFormatter.timeStyle = .none
            }
            let str = dateFormatter.string(from: date)
            return str
        } else {
            return ""
        }
    }
    
    // MARK: - Strings
    let s_NavTitle = "Transactions"
    let s_ID = "ID"
    let s_Summary = "Summary"
    let s_TxnDate = "Transaction Date"
    let s_NZTime = "NZ Time"
    let s_Amount = "Amount"
    let s_GST = "GST (15%)"
    let s_Credit = "Credit"
    let s_Debit = "Debit"
    
    // MARK: - Private properties & functions
    private let url = URL(string: "https://gist.githubusercontent.com/Josh-Ng/500f2716604dc1e8e2a3c6d31ad01830/raw/4d73acaa7caa1167676445c922835554c5572e82/test-data.json")!
    
    private func getData() {
        Task.init {
            do {
                let (data, _) = try await restClient.apiRequest(url)
                self.transactions = getTransactions(data)
            } catch {
                // TODO: - Handle error
                print(error)
            }
        }
    }
    
    private func getTransactions(_ data: Data) -> [String: [Transaction]] {
        guard let parsedTxns = parse(data) else { return [String: [Transaction]]() }
        let sortedTxns = parsedTxns.sorted(by: { $0.transactionDate > $1.transactionDate })
        let groupedTxns = Dictionary(grouping: sortedTxns) { String($0.transactionDate.prefix(10)) }
        return groupedTxns
    }
    
    private func parse(_ data: Data) -> [Transaction]? {
        guard let txns = try? JSONDecoder().decode([Transaction].self, from: data) else {
            // TODO: - Handle error
            return nil
        }
        return txns
    }
}
