//
//  CategoryPickerView.swift
//  Spendee
//
//  Created by Kuba Rejmann on 30/12/2025.
//

import SwiftUI
import SwiftData

struct CategoryPickerView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedCategory: TransactionCategory?

    @Query(sort: \TransactionCategory.name) private var categories: [TransactionCategory]
    
    @State private var selectedType: TransactionType = .expense
    
    let columns = [GridItem(.adaptive(minimum: 80))]
    
    var filteredCategories: [TransactionCategory] {
        categories.filter { $0.type == selectedType }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Picker("Type", selection: $selectedType) {
                    ForEach(TransactionType.allCases, id: \.self) { type in
                        Text(type.localizedName).tag(type)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(filteredCategories, id: \.id) { category in
                            Button {
                                selectedCategory = category
                                dismiss()
                            } label: {
                                VStack {
                                    Circle()
                                        .fill(Color(hex: category.colorHex))
                                        .frame(width: 50, height: 50)
                                        .overlay {
                                            Image(systemName: category.symbolName)
                                                .foregroundStyle(.white)
                                                .font(.headline)
                                        }
                                    
                                    Text(category.name)
                                        .font(.caption)
                                        .multilineTextAlignment(.center)
                                        .lineLimit(1)
                                        
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Select Category")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
}

// MARK: - Previews

#Preview {
    CategoryPickerView(selectedCategory: .constant(nil))
        .modelContainer(PreviewHelper.container)
}
