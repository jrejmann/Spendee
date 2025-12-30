//
//  PreviewHelper.swift
//  Spendee
//
//  Created by Kuba Rejmann on 30/12/2025.
//

import SwiftData

@MainActor
struct PreviewHelper {
    
    static let container: ModelContainer = {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        do {
            let container = try ModelContainer(for: Transaction.self, TransactionCategory.self, configurations: config)
            
            for category in TransactionCategory.defaults {
                container.mainContext.insert(category)
            }
            
            for transaction in Transaction.examples {
                container.mainContext.insert(transaction)
            }
            
            return container
        } catch {
            fatalError("Failed to create preview container: \(error)")
        }
    }()
}
