//
//  TransactionDetailViewModel.swift
//  Spendee
//
//  Created by Kuba Rejmann on 30/12/2025.
//

import Foundation
import Observation
import SwiftData

@Observable
final class TransactionDetailViewModel {
    var amount: Decimal = 0.0
    var selectedCurrency: Currency = .usd
    var date: Date = .now
    var note: String = ""
    var selectedCategory: TransactionCategory?

    var isShowingCategoryPicker = false
    var isShowingDeleteAlert = false

    private var transactionToEdit: Transaction?

    var isEditing: Bool { transactionToEdit != nil }
    var isSaveDisabled: Bool { selectedCategory == nil || amount == 0 }

    init(transaction: Transaction? = nil) {
        self.transactionToEdit = transaction

        if let t = transaction {
            self.amount = t.amount
            self.date = t.date
            self.note = t.note ?? ""
            self.selectedCategory = t.category
            if let code = Currency(rawValue: t.currencyCode) {
                self.selectedCurrency = code
            }
        }
    }

    func save(context: ModelContext) {
        if let existing = transactionToEdit {
            existing.amount = amount
            existing.currencyCode = selectedCurrency.rawValue
            existing.date = date
            existing.note = note.isEmpty ? nil : note
            existing.category = selectedCategory
        } else {
            let newTransaction = Transaction(
                amount: amount,
                currencyCode: selectedCurrency.rawValue,
                date: date,
                note: note.isEmpty ? nil : note,
                category: selectedCategory
            )
            context.insert(newTransaction)
        }
    }

    func delete(context: ModelContext) {
        if let transaction = transactionToEdit {
            context.delete(transaction)
        }
    }
}
