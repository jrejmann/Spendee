//
//  SpendeeApp.swift
//  Spendee
//
//  Created by Kuba Rejmann on 30/12/2025.
//

import SwiftUI
import SwiftData

@main
struct SpendeeApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Transaction.self,
            TransactionCategory.self
        ])
        
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    seedDataIfNeeded()
                }
        }
        .modelContainer(sharedModelContainer)
    }
    
    // MARK: - Seeding Logic
    
    @MainActor
    private func seedDataIfNeeded() {
        let context = sharedModelContainer.mainContext
        
        do {
            let descriptor = FetchDescriptor<TransactionCategory>()
            let count = try context.fetchCount(descriptor)
            
            if count == 0 {
                print("Database is empty. Seeding default categories...")
                
                let defaults = TransactionCategory.defaults
                
                for category in defaults {
                    context.insert(category)
                }
                
                try context.save()
                print("Seeding complete.")
            }
        } catch {
            print("Failed to seed data: \(error)")
        }
    }
}
