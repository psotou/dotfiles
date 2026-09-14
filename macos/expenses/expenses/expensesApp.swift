//
//  expensesApp.swift
//  expenses
//
//  Created by Pascual Soto Uribe on 14-09-26.
//

import SwiftUI
import SwiftData
import UIKit

@main
struct expensesApp: App {
    init() {
        UIView.setAnimationsEnabled(false)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [ExpenseRecord.self, PersonProfile.self, ExpenseCategoryRecord.self])
    }
}
