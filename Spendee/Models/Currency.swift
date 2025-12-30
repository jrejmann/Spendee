//
//  Currency.swift
//  Spendee
//
//  Created by Kuba Rejmann on 30/12/2025.
//

import Foundation

enum Currency: String, CaseIterable, Identifiable {
    case usd = "USD"
    case eur = "EUR"
    case pln = "PLN"
    case gbp = "GBP"
    
    var id: String { rawValue }
    var symbol: String {
        Locale(identifier: Locale.identifier(fromComponents: [NSLocale.Key.currencyCode.rawValue: rawValue]))
            .currencySymbol ?? rawValue
    }
}
