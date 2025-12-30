//
//  TransactionCategory.swift
//  Spendee
//
//  Created by Kuba Rejmann on 30/12/2025.
//

import Foundation
import SwiftData

@Model
final class TransactionCategory {
    @Attribute(.unique) var id: String
    
    var name: String
    var symbolName: String
    var colorHex: String
    var type: TransactionType

    @Relationship(deleteRule: .nullify, inverse: \Transaction.category)
    var transactions: [Transaction]? = []
    
    init(id: String, name: String, symbolName: String, colorHex: String, type: TransactionType) {
        self.id = id
        self.name = name
        self.symbolName = symbolName
        self.colorHex = colorHex
        self.type = type
    }
}

// MARK: - Extensions

extension TransactionCategory {
    
    // Income categories
    static let business = TransactionCategory(
        id: "business",
        name: "Business",
        symbolName: "briefcase.fill",
        colorHex: "ffa200",
        type: .income
    )
    static let salary = TransactionCategory(
        id: "salary",
        name: "Salary",
        symbolName: "banknote.fill",
        colorHex: "18b272",
        type: .income
    )
    static let giftIncome = TransactionCategory(
        id: "gift_income",
        name: "Gift",
        symbolName: "gift.fill",
        colorHex: "18b272",
        type: .income
    )
    static let additionalIncome = TransactionCategory(
        id: "additional_income",
        name: "Additional Income",
        symbolName: "plus.circle.fill",
        colorHex: "72c541",
        type: .income
    )
    static let loan = TransactionCategory(
        id: "loan",
        name: "Loan",
        symbolName: "gift.fill",
        colorHex: "e06476",
        type: .income
    )
    static let otherIncome = TransactionCategory(
        id: "other_income",
        name: "Other",
        symbolName: "chart.bar.fill",
        colorHex: "67686c",
        type: .income
    )

    // Expense categories
    static let sportHobby = TransactionCategory(
        id: "sport_hobby",
        name: "Sport & Hobby",
        symbolName: "basketball.fill",
        colorHex: "60D1CB",
        type: .expense
    )
    static let car = TransactionCategory(
        id: "car",
        name: "Car",
        symbolName: "car.fill",
        colorHex: "45A7E6",
        type: .expense
    )
    static let travel = TransactionCategory(
        id: "travel",
        name: "Travel",
        symbolName: "airplane",
        colorHex: "F964A0",
        type: .expense
    )
    static let giftExpense = TransactionCategory(
        id: "gift_expense",
        name: "Gift",
        symbolName: "gift.fill",
        colorHex: "18b272",
        type: .expense
    )
    static let house = TransactionCategory(
        id: "house",
        name: "House",
        symbolName: "house.fill",
        colorHex: "b6985c",
        type: .expense
    )
    static let transport = TransactionCategory(
        id: "transport",
        name: "Transport",
        symbolName: "tram.fill",
        colorHex: "fcce00",
        type: .expense
    )
    static let foodAndDrinks = TransactionCategory(
        id: "food_and_drinks",
        name: "Food and drinks",
        symbolName: "fork.knife",
        colorHex: "ffa801",
        type: .expense
    )
    static let entertainment = TransactionCategory(
        id: "entertainment",
        name: "Entertainment",
        symbolName: "gamecontroller.fill",
        colorHex: "ffa801",
        type: .expense
    )
    static let health = TransactionCategory(
        id: "health",
        name: "Health",
        symbolName: "heart.text.square.fill",
        colorHex: "e06476",
        type: .expense
    )
    static let billsPayments = TransactionCategory(
        id: "bills_payments",
        name: "Bills & Payments",
        symbolName: "doc.text.fill",
        colorHex: "5ec4ac",
        type: .expense
    )
    static let education = TransactionCategory(
        id: "education",
        name: "Education",
        symbolName: "book.closed.fill",
        colorHex: "3a75ad",
        type: .expense
    )
    static let personalFamily = TransactionCategory(
        id: "personal_family",
        name: "Personal & Family",
        symbolName: "person.fill",
        colorHex: "45a7e6",
        type: .expense
    )
    static let beauty = TransactionCategory(
        id: "beauty",
        name: "Beauty",
        symbolName: "sparkles",
        colorHex: "7944d0",
        type: .expense
    )
    static let work = TransactionCategory(
        id: "work",
        name: "Work",
        symbolName: "briefcase.fill",
        colorHex: "6d6e8a",
        type: .expense
    )
    static let shopping = TransactionCategory(
        id: "shopping",
        name: "Shopping",
        symbolName: "bag.fill",
        colorHex: "e36aef",
        type: .expense
    )
    static let groceries = TransactionCategory(
        id: "groceries",
        name: "Groceries",
        symbolName: "cart.fill",
        colorHex: "34C759",
        type: .expense
    )
    static let otherExpense = TransactionCategory(
        id: "other_expense",
        name: "Other",
        symbolName: "ellipsis.circle.fill",
        colorHex: "67686c",
        type: .expense
    )

    // Aggregates
    static let incomeCategories: [TransactionCategory] = [
        business, salary, giftIncome, additionalIncome, loan, otherIncome
    ]
    static let expenseCategories: [TransactionCategory] = [
        sportHobby, car, travel, giftExpense, house, transport, foodAndDrinks, entertainment,
        health, billsPayments, education, personalFamily, beauty, work, shopping, groceries, otherExpense
    ]

    static let defaults: [TransactionCategory] = incomeCategories + expenseCategories
}

