//
//  ContentView.swift
//  Spendee
//
//  Created by Kuba Rejmann on 30/12/2025.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    var body: some View {
        TransactionListView()
    }
}

#Preview {
    ContentView()
        .modelContainer(PreviewHelper.container)
}
