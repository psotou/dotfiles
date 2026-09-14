//
//  expensesApp.swift
//  expenses
//
//  Created by Pascual Soto Uribe on 14-09-26.
//

import SwiftUI
import SwiftData

@main
struct expensesApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [ExpenseRecord.self, PersonProfile.self, ExpenseCategoryRecord.self])
    }
}
