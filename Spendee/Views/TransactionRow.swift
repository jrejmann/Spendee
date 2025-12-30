//
//  TransactionRow.swift
//  Spendee
//
//  Created by Kuba Rejmann on 30/12/2025.
//

import SwiftUI

struct TransactionRow: View {
    let transaction: Transaction
    
    var body: some View {
        HStack {
            Image(systemName: transaction.category?.symbolName ?? "circle")
                .foregroundStyle(Color(hex: transaction.category?.colorHex ?? "000000"))
                .padding(.horizontal, 6)
            
            VStack(alignment: .leading) {
                Text(transaction.category?.name ?? "Uncategorized")
                    .font(.headline)
                Text(transaction.note ?? "")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Text(transaction.amount, format: .currency(code: transaction.currencyCode))
                .foregroundStyle(transaction.category?.type == .expense ? .red : .green)
        }
    }
}

// MARK: - Previews

#Preview {
    TransactionRow(transaction: .rent)
        .padding()
}
