//
//  Transaction.swift
//  Spendee
//
//  Created by Kuba Rejmann on 30/12/2025.
//

import Foundation
import SwiftData

enum TransactionType: String, Codable, CaseIterable {
    case income
    case expense
    
    var localizedName: String {
        switch self {
        case .income: return "Income"
        case .expense: return "Expense"
        }
    }
}

@Model
final class Transaction {
    var id: UUID = UUID()
    
    var amount: Decimal
    var currencyCode: String
    var date: Date
    var note: String?
    
    var category: TransactionCategory?
    
    var signedAmount: Decimal {
        guard let category = category else { return amount }
        return category.type == .expense ? -amount : amount
    }
    
    init(amount: Decimal, currencyCode: String = "PLN", date: Date = .now, note: String? = nil, category: TransactionCategory? = nil) {
        self.id = UUID()
        self.amount = amount
        self.currencyCode = currencyCode
        self.date = date
        self.note = note
        self.category = category
    }
}

// MARK: - Extensions

extension Transaction {
    static let rent = Transaction(
        amount: 1200,
        date: .now,
        note: "Rent Payment",
        category: .house
    )
    
    static let paycheck = Transaction(
        amount: 4500,
        date: .now.addingTimeInterval(-86400 * 5),
        note: "Monthly Salary",
        category: .salary
    )
    
    static let groceryRun = Transaction(
        amount: 154.20,
        date: .now,
        note: "Weekly shopping",
        category: .groceries
    )
    
    static let examples: [Transaction] = [rent, paycheck, groceryRun]
}
