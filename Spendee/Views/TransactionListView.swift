//
//  TransactionListView.swift
//  Spendee
//
//  Created by Kuba Rejmann on 30/12/2025.
//

//
//  TransactionListView.swift
//  Spendee
//
//  Created by Kuba Rejmann on 30/12/2025.
//

import SwiftUI
import SwiftData

struct TransactionListView: View {
    @Environment(\.modelContext) private var modelContext
    
    @State private var showingAddSheet = false
    @State private var transactionToEdit: Transaction?
    
    @State private var transactionToDelete: Transaction?
    
    @Query(sort: \Transaction.date, order: .reverse) private var transactions: [Transaction]
    
    var body: some View {
        NavigationStack {
            Group {
                if transactions.isEmpty {
                    ContentUnavailableView {
                        Label("No Transactions", systemImage: "tray.fill")
                    } description: {
                        Text("Start tracking your income and expenses by adding your first transaction.")
                    } actions: {
                        Button("Add Transaction") {
                            showingAddSheet = true
                        }
                        .buttonStyle(.borderedProminent)
                    }
                } else {
                    List {
                        ForEach(transactions) { transaction in
                            TransactionRow(transaction: transaction)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    transactionToEdit = transaction
                                }
                        }
                        .onDelete(perform: promptToDelete)
                    }
                }
            }
            .navigationTitle("Transactions")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: { showingAddSheet = true }) {
                        Label("Add", systemImage: "plus")
                    }
                    .foregroundStyle(.primary)
                }
            }
            .sheet(isPresented: $showingAddSheet) {
                TransactionDetailView()
            }
            .sheet(item: $transactionToEdit) { transaction in
                TransactionDetailView(transaction: transaction)
            }
            .alert(
                "Delete Transaction?",
                isPresented: Binding(
                    get: { transactionToDelete != nil },
                    set: { if !$0 { transactionToDelete = nil } }
                )
            ) {
                Button("Delete", role: .destructive) {
                    if let transaction = transactionToDelete {
                        withAnimation {
                            modelContext.delete(transaction)
                        }
                    }
                    transactionToDelete = nil
                }
                
                Button("Cancel", role: .cancel) {
                    transactionToDelete = nil
                }
            } message: {
                Text("Are you sure you want to delete this transaction? This action cannot be undone.")
            }
        }
    }
    
    private func promptToDelete(at offsets: IndexSet) {
        if let index = offsets.first {
            transactionToDelete = transactions[index]
        }
    }
}

// MARK: - Previews

#Preview("Empty") {
    TransactionListView()
}

#Preview("Filled") {
    TransactionListView()
        .modelContainer(PreviewHelper.container)
}
