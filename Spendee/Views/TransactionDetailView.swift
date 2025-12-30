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
        _viewModel = State(
            initialValue: TransactionDetailViewModel(transaction: transaction)
        )
    }

    var body: some View {
        NavigationStack {
            Form {
                HeaderSection(
                    amount: $viewModel.amount,
                    currency: $viewModel.selectedCurrency,
                    category: viewModel.selectedCategory,
                    onCategoryTap: { viewModel.isShowingCategoryPicker = true }
                )

                DetailsSection(
                    date: $viewModel.date,
                    note: $viewModel.note,
                    accentColorHex: viewModel.selectedCategory?.colorHex
                )
            }
            .navigationTitle(
                viewModel.isEditing ? "Edit Transaction" : "New Transaction"
            )
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                
                if viewModel.isEditing {
                    ToolbarItem(placement: .bottomBar) {
                        Button(role: .destructive) {
                            viewModel.isShowingDeleteAlert = true
                        } label: {
                            Image(systemName: "trash")
                                .foregroundStyle(.red)
                        }
                    }
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
                CategoryPickerView(
                    selectedCategory: $viewModel.selectedCategory
                )
            }
            .alert("Delete Transaction?", isPresented: $viewModel.isShowingDeleteAlert) {
                Button("Delete", role: .destructive) {
                    viewModel.delete(context: modelContext)
                    dismiss()
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("Are you sure? This action cannot be undone.")
            }
        }
    }
}

// MARK: - Composites

private struct HeaderSection: View {
    @Binding var amount: Decimal
    @Binding var currency: Currency
    let category: TransactionCategory?
    let onCategoryTap: () -> Void

    var body: some View {
        Section {
            HStack(alignment: .center, spacing: 15) {
                Button(action: onCategoryTap) {
                    VStack {
                        CategoryIconView(category: category)

                        Text(category?.name ?? "Select")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
                .buttonStyle(.plain)

                Spacer()

                HStack {
                    TextField(
                        "0.00",
                        value: $amount,
                        format: .number.precision(.fractionLength(2))
                    )
                    .keyboardType(.decimalPad)
                    .font(.system(size: 34, weight: .bold))
                    .multilineTextAlignment(.trailing)

                    Picker("", selection: $currency) {
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
    }
}

private struct CategoryIconView: View {
    let category: TransactionCategory?

    var body: some View {
        if let category = category {
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
    }
}

private struct DetailsSection: View {
    @Binding var date: Date
    @Binding var note: String
    let accentColorHex: String?

    var iconColor: Color {
        if let hex = accentColorHex {
            return Color(hex: hex)
        }
        return .primary
    }

    var body: some View {
        Section {
            HStack {
                Image(systemName: "calendar")
                    .font(.system(size: 20))
                    .foregroundStyle(iconColor)

                DatePicker(
                    "Date",
                    selection: $date,
                    displayedComponents: [.date]
                )
            }

            HStack(alignment: .top) {
                Image(systemName: "pencil")
                    .font(.system(size: 20))
                    .foregroundStyle(iconColor)

                TextField("Note (Optional)", text: $note, axis: .vertical)
                    .lineLimit(2...4)
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
