//
//  TransactionDetailView.swift
//  Spendee
//
//  Created by Kuba Rejmann on 30/12/2025.
//

import SwiftData
import SwiftUI

struct TransactionDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var viewModel: TransactionDetailViewModel

    init(transaction: Transaction? = nil) {
        _viewModel = State(initialValue: TransactionDetailViewModel(transaction: transaction))
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    HStack(alignment: .center, spacing: 15) {
                        
                        Button {
                            viewModel.isShowingCategoryPicker = true
                        } label: {
                            VStack {
                                if let category = viewModel.selectedCategory {
                                    Circle()
                                        .fill(Color(hex: category.colorHex))
                                        .frame(width: 48, height: 48)
                                        .overlay {
                                            Image(systemName: category.symbolName)
                                                .foregroundStyle(.white)
                                        }
                                } else {
                                    Circle()
                                        .fill(Color.gray.opacity(0.2))
                                        .frame(width: 48, height: 48)
                                        .overlay {
                                            Image(systemName: "questionmark")
                                                .foregroundStyle(.gray)
                                        }
                                }
                                Text(viewModel.selectedCategory?.name ?? "Select")
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .buttonStyle(.plain)
                        
                        Spacer()
                        
                        HStack {
                            TextField(
                                "0.00",
                                value: $viewModel.amount,
                                format: .number.precision(.fractionLength(2))
                            )
                            .keyboardType(.decimalPad)
                            .font(.system(size: 34, weight: .bold))
                            .multilineTextAlignment(.trailing)

                            Picker("", selection: $viewModel.selectedCurrency) {
                                ForEach(Currency.allCases) { currency in
                                    Text(currency.rawValue).tag(currency)
                                }
                            }
                            .labelsHidden()
                        }
                        .frame(maxWidth: 250, alignment: .trailing)
                    }
                    .padding(.vertical, 8)
                }
                
                Section {
                    HStack {
                        Image(systemName: "calendar")
                            .font(.system(size: 20))
                            .foregroundStyle(Color(hex: viewModel.selectedCategory?.colorHex ?? "000000"))
                        
                        DatePicker(
                            "Date",
                            selection: $viewModel.date,
                            displayedComponents: [.date]
                        )
                    }
                    
                    HStack(alignment: .top) {
                        Image(systemName: "pencil")
                            .font(.system(size: 20))
                            .foregroundStyle(Color(hex: viewModel.selectedCategory?.colorHex ?? "000000"))
                        
                        TextField("Note (Optional)", text: $viewModel.note, axis: .vertical)
                            .lineLimit(2...4)
                    }
                }
            }
            .navigationTitle(viewModel.isEditing ? "Edit Transaction" : "New Transaction")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        viewModel.save(context: modelContext)
                        dismiss()
                    }
                    .disabled(viewModel.isSaveDisabled)
                }
            }
            .sheet(isPresented: $viewModel.isShowingCategoryPicker) {
                CategoryPickerView(selectedCategory: $viewModel.selectedCategory)
            }
        }
    }
}

// MARK: - Previews
#Preview("Create") {
    TransactionDetailView()
        .modelContainer(PreviewHelper.container)
}

#Preview("Edit") {
    TransactionDetailView(transaction: .rent)
        .modelContainer(PreviewHelper.container)
}

