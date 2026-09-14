//
//  ContentView.swift
//  expenses
//
//  Created by Pascual Soto Uribe on 14-09-26.
//

import SwiftUI
import Combine
import PhotosUI
import UIKit
import SwiftData

struct Expense: Identifiable, Hashable, Codable {
    let id: UUID
    let person: Person
    let categoryName: String
    let categorySymbol: String
    let amount: Double
    let date: Date

    init(id: UUID = UUID(), person: Person, categoryName: String, categorySymbol: String, amount: Double, date: Date) {
        self.id = id
        self.person = person
        self.categoryName = categoryName
        self.categorySymbol = categorySymbol
        self.amount = amount
        self.date = date
    }

    private enum CodingKeys: String, CodingKey { case id, person, category, categoryName, categorySymbol, amount, date }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        person = try container.decode(Person.self, forKey: .person)
        let oldCategory = try container.decodeIfPresent(ExpenseCategory.self, forKey: .category)
        categoryName = try container.decodeIfPresent(String.self, forKey: .categoryName) ?? oldCategory?.rawValue ?? "Other"
        categorySymbol = try container.decodeIfPresent(String.self, forKey: .categorySymbol) ?? oldCategory?.symbol ?? "tag.fill"
        amount = try container.decode(Double.self, forKey: .amount)
        date = try container.decode(Date.self, forKey: .date)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(person, forKey: .person)
        try container.encode(categoryName, forKey: .categoryName)
        try container.encode(categorySymbol, forKey: .categorySymbol)
        try container.encode(amount, forKey: .amount)
        try container.encode(date, forKey: .date)
    }
}

@Model
final class ExpenseRecord {
    var id: UUID
    var personID: String
    var categoryName: String
    var categorySymbol: String = "tag.fill"
    var amount: Double
    var date: Date

    init(id: UUID = UUID(), personID: String, categoryName: String, categorySymbol: String = "tag.fill", amount: Double, date: Date) {
        self.id = id
        self.personID = personID
        self.categoryName = categoryName
        self.categorySymbol = categorySymbol
        self.amount = amount
        self.date = date
    }
}

@Model
final class ExpenseCategoryRecord {
    var id: UUID
    var name: String
    var symbol: String
    var sortOrder: Int

    init(id: UUID = UUID(), name: String, symbol: String = "tag.fill", sortOrder: Int) {
        self.id = id
        self.name = name
        self.symbol = symbol
        self.sortOrder = sortOrder
    }
}

@Model
final class PersonProfile {
    var personID: String
    var name: String
    var photoData: Data?

    init(personID: String, name: String, photoData: Data? = nil) {
        self.personID = personID
        self.name = name
        self.photoData = photoData
    }
}

enum Person: String, CaseIterable, Identifiable, Codable {
    case alex = "Alex"
    case sam = "Sam"

    var id: String { rawValue }
    var defaultName: String { rawValue }
    var color: Color { self == .alex ? .indigo : .teal }
    var initials: String { self == .alex ? "A" : "S" }
}

enum ExpenseCategory: String, CaseIterable, Identifiable, Codable {
    case groceries = "Groceries"
    case restaurants = "Dining out"
    case electricity = "Electricity"
    case water = "Water"
    case internet = "Internet"
    case phones = "Phones"
    case gas = "Gas"
    case transport = "Transport"
    case rent = "Rent"
    case health = "Health"
    case insurance = "Insurance"
    case subscriptions = "Subscriptions"
    case home = "Home"
    case pets = "Pets"
    case other = "Other"

    var id: String { rawValue }

    var symbol: String {
        switch self {
        case .groceries: "cart.fill"
        case .restaurants: "fork.knife"
        case .electricity: "bolt.fill"
        case .water: "drop.fill"
        case .internet: "wifi"
        case .phones: "phone.fill"
        case .gas: "fuelpump.fill"
        case .transport: "bus.fill"
        case .rent: "house.fill"
        case .health: "heart.fill"
        case .insurance: "shield.fill"
        case .subscriptions: "play.rectangle.fill"
        case .home: "lamp.desk.fill"
        case .pets: "pawprint.fill"
        case .other: "square.grid.2x2.fill"
        }
    }
}

enum SpendingPeriod: String, CaseIterable, Identifiable {
    case week = "This week"
    case month = "This month"
    case year = "This year"

    var id: String { rawValue }

    func contains(_ date: Date, relativeTo referenceDate: Date = .now) -> Bool {
        let calendar = Calendar.current
        switch self {
        case .week:
            return calendar.isDate(date, equalTo: referenceDate, toGranularity: .weekOfYear)
        case .month:
            return calendar.isDate(date, equalTo: referenceDate, toGranularity: .month)
        case .year:
            return calendar.isDate(date, equalTo: referenceDate, toGranularity: .year)
        }
    }
}

@MainActor
final class ExpenseStore: ObservableObject {
    @Published private(set) var expenses: [Expense] = []
    @Published private(set) var personNames: [String: String] = [:]
    @Published private(set) var personImageData: [String: Data] = [:]
    @Published private(set) var categories: [ExpenseCategoryRecord] = []

    private var modelContext: ModelContext?
    private var profiles: [String: PersonProfile] = [:]

    private let legacyExpensesKey = "savedExpenses"
    private let legacyPeopleKey = "personNames"
    private let legacyImagesKey = "personImages"

    func configure(with context: ModelContext) {
        guard modelContext == nil else { return }
        modelContext = context

        let legacyNames = UserDefaults.standard.dictionary(forKey: legacyPeopleKey) as? [String: String] ?? [:]
        let legacyImages = UserDefaults.standard.dictionary(forKey: legacyImagesKey) as? [String: Data] ?? [:]
        let savedProfiles = (try? context.fetch(FetchDescriptor<PersonProfile>())) ?? []
        profiles = Dictionary(uniqueKeysWithValues: savedProfiles.map { ($0.personID, $0) })
        for person in Person.allCases where profiles[person.id] == nil {
            let profile = PersonProfile(
                personID: person.id,
                name: legacyNames[person.id] ?? person.defaultName,
                photoData: legacyImages[person.id]
            )
            profiles[person.id] = profile
            context.insert(profile)
        }
        refreshProfiles()

        let savedExpenses = (try? context.fetch(FetchDescriptor<ExpenseRecord>())) ?? []
        expenses = savedExpenses.compactMap { record in
            guard let person = Person(rawValue: record.personID) else { return nil }
            return Expense(id: record.id, person: person, categoryName: record.categoryName, categorySymbol: record.categorySymbol, amount: record.amount, date: record.date)
        }

        if expenses.isEmpty {
            if let legacyData = UserDefaults.standard.data(forKey: legacyExpensesKey),
               let legacyExpenses = try? JSONDecoder().decode([Expense].self, from: legacyData) {
                expenses = legacyExpenses
                for expense in legacyExpenses {
                    context.insert(ExpenseRecord(id: expense.id, personID: expense.person.rawValue, categoryName: expense.categoryName, categorySymbol: expense.categorySymbol, amount: expense.amount, date: expense.date))
                }
            } else {
                seedSampleExpenses()
            }
        }

        categories = ((try? context.fetch(FetchDescriptor<ExpenseCategoryRecord>())) ?? [])
            .sorted { $0.sortOrder < $1.sortOrder }
        if categories.isEmpty {
            categories = ExpenseCategory.allCases.enumerated().map { index, category in
                let record = ExpenseCategoryRecord(name: category.rawValue, symbol: category.symbol, sortOrder: index)
                context.insert(record)
                return record
            }
        }
        try? context.save()
        UserDefaults.standard.removeObject(forKey: legacyExpensesKey)
        UserDefaults.standard.removeObject(forKey: legacyPeopleKey)
        UserDefaults.standard.removeObject(forKey: legacyImagesKey)
    }

    private func refreshProfiles() {
        personNames = profiles.reduce(into: [:]) { $0[$1.key] = $1.value.name }
        personImageData = profiles.reduce(into: [:]) { result, entry in
            if let photoData = entry.value.photoData { result[entry.key] = photoData }
        }
    }

    private func seedSampleExpenses() {
        add(person: .alex, categoryName: ExpenseCategory.rent.rawValue, categorySymbol: ExpenseCategory.rent.symbol, amount: 850, date: .now)
        add(person: .alex, categoryName: ExpenseCategory.groceries.rawValue, categorySymbol: ExpenseCategory.groceries.symbol, amount: 124.50, date: .now)
        add(person: .alex, categoryName: ExpenseCategory.gas.rawValue, categorySymbol: ExpenseCategory.gas.symbol, amount: 58.20, date: .now)
        add(person: .sam, categoryName: ExpenseCategory.groceries.rawValue, categorySymbol: ExpenseCategory.groceries.symbol, amount: 96.30, date: .now)
        add(person: .sam, categoryName: ExpenseCategory.internet.rawValue, categorySymbol: ExpenseCategory.internet.symbol, amount: 49.99, date: .now)
        add(person: .sam, categoryName: ExpenseCategory.electricity.rawValue, categorySymbol: ExpenseCategory.electricity.symbol, amount: 73.40, date: .now)
    }

    func name(for person: Person) -> String {
        let savedName = personNames[person.id]?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        return savedName.isEmpty ? person.defaultName : savedName
    }

    func setName(_ name: String, for person: Person) {
        guard let profile = profiles[person.id] else { return }
        profile.name = name
        personNames[person.id] = name
        try? modelContext?.save()
    }

    func image(for person: Person) -> UIImage? {
        guard let data = personImageData[person.id] else { return nil }
        return UIImage(data: data)
    }

    func setImage(_ data: Data, for person: Person) {
        guard let profile = profiles[person.id] else { return }
        profile.photoData = data
        personImageData[person.id] = data
        try? modelContext?.save()
    }

    func total(for person: Person, during period: SpendingPeriod = .month, relativeTo referenceDate: Date = .now) -> Double {
        expenses.filter { $0.person == person && period.contains($0.date, relativeTo: referenceDate) }
            .reduce(0) { $0 + $1.amount }
    }

    func total(during period: SpendingPeriod, relativeTo referenceDate: Date = .now) -> Double {
        Person.allCases.reduce(0) { $0 + total(for: $1, during: period, relativeTo: referenceDate) }
    }

    func expenses(for person: Person, during period: SpendingPeriod, relativeTo referenceDate: Date = .now) -> [Expense] {
        expenses.filter { $0.person == person && period.contains($0.date, relativeTo: referenceDate) }.sorted { $0.date > $1.date }
    }

    func add(person: Person, categoryName: String, categorySymbol: String, amount: Double, date: Date) {
        let expense = Expense(person: person, categoryName: categoryName, categorySymbol: categorySymbol, amount: amount, date: date)
        expenses.insert(expense, at: 0)
        modelContext?.insert(ExpenseRecord(id: expense.id, personID: person.rawValue, categoryName: categoryName, categorySymbol: categorySymbol, amount: amount, date: date))
        try? modelContext?.save()
    }

    func addCategory(name: String) {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty,
              !categories.contains(where: { $0.name.localizedCaseInsensitiveCompare(trimmedName) == .orderedSame }) else { return }
        let category = ExpenseCategoryRecord(name: trimmedName, sortOrder: categories.count)
        modelContext?.insert(category)
        categories.append(category)
        try? modelContext?.save()
    }

    func renameCategory(_ category: ExpenseCategoryRecord, to name: String) {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty,
              !categories.contains(where: {
                  $0.id != category.id && $0.name.localizedCaseInsensitiveCompare(trimmedName) == .orderedSame
              }) else { return }
        let previousName = category.name
        category.name = trimmedName
        if let records = try? modelContext?.fetch(FetchDescriptor<ExpenseRecord>()) {
            for record in records where record.categoryName == previousName {
                record.categoryName = trimmedName
            }
        }
        expenses = expenses.map { expense in
            guard expense.categoryName == previousName else { return expense }
            return Expense(id: expense.id, person: expense.person, categoryName: trimmedName, categorySymbol: expense.categorySymbol, amount: expense.amount, date: expense.date)
        }
        categories = categories
        try? modelContext?.save()
    }

    func deleteCategory(_ category: ExpenseCategoryRecord) {
        guard categories.count > 1 else { return }
        modelContext?.delete(category)
        categories.removeAll { $0.id == category.id }
        try? modelContext?.save()
    }
}

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var store = ExpenseStore()
    @State private var showingAddExpense = false

    var body: some View {
        TabView {
            DashboardView(showingAddExpense: $showingAddExpense)
                .environmentObject(store)
                .tabItem { Label("Overview", systemImage: "chart.pie.fill") }
            ExpenseListView()
                .environmentObject(store)
                .tabItem { Label("Expenses", systemImage: "list.bullet.rectangle") }
            PeopleView()
                .environmentObject(store)
                .tabItem { Label("People", systemImage: "person.2.fill") }
            CategoriesView()
                .environmentObject(store)
                .tabItem { Label("Items", systemImage: "tag.fill") }
        }
        .tint(.indigo)
        .environmentObject(store)
        .sheet(isPresented: $showingAddExpense) { AddExpenseView().environmentObject(store) }
        .onAppear { store.configure(with: modelContext) }
        .transaction { transaction in
            transaction.animation = nil
            transaction.disablesAnimations = true
        }
    }
}

private struct DashboardView: View {
    @EnvironmentObject private var store: ExpenseStore
    @Binding var showingAddExpense: Bool
    @State private var selectedPeriod: SpendingPeriod = .month

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .leading, spacing: 6) {
                        Picker("Period", selection: $selectedPeriod) {
                            ForEach(SpendingPeriod.allCases) { Text($0.rawValue).tag($0) }
                        }
                        .pickerStyle(.segmented)
                        Text(selectedPeriod.rawValue).font(.subheadline.weight(.medium)).foregroundStyle(.secondary)
                        Text(store.total(during: selectedPeriod), format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                            .font(.system(size: 38, weight: .bold, design: .rounded))
                        Text("Total spent \(selectedPeriod.rawValue.lowercased())").font(.subheadline).foregroundStyle(.secondary)
                    }
                    VStack(spacing: 12) {
                        ForEach(Person.allCases) { person in
                            PersonSummaryRow(person: person, total: store.total(for: person, during: selectedPeriod), overallTotal: store.total(during: selectedPeriod))
                        }
                    }
                    Button { showingAddExpense = true } label: {
                        Label("Add expense", systemImage: "plus")
                            .font(.headline).frame(maxWidth: .infinity).padding(.vertical, 8)
                    }
                    .buttonStyle(.borderedProminent).controlSize(.large)
                }
                .padding()
            }
            .navigationTitle("Household")
        }
    }
}

private struct PersonSummaryRow: View {
    @EnvironmentObject private var store: ExpenseStore
    let person: Person
    let total: Double
    let overallTotal: Double

    var body: some View {
        HStack(spacing: 12) {
            PersonAvatar(person: person, size: 42)
            VStack(alignment: .leading, spacing: 3) {
                Text(store.name(for: person)).font(.headline)
                Text(overallTotal == 0 ? "0% of total" : "\(Int((total / overallTotal * 100).rounded()))% of total")
                    .font(.caption).foregroundStyle(.secondary)
            }
            Spacer()
            Text(total, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                .font(.headline.monospacedDigit())
        }
        .padding(14).background(.background, in: RoundedRectangle(cornerRadius: 16))
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(person.color.opacity(0.22), lineWidth: 1))
    }
}

private struct PersonAvatar: View {
    @EnvironmentObject private var store: ExpenseStore
    let person: Person
    let size: CGFloat

    var body: some View {
        Group {
            if let image = store.image(for: person) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            } else {
                Text(person.initials)
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(person.color)
            }
        }
        .frame(width: size, height: size)
        .clipShape(Circle())
    }
}

private struct ExpenseListView: View {
    @EnvironmentObject private var store: ExpenseStore
    @State private var selectedPerson: Person = .alex
    @State private var selectedYear = Calendar.current.component(.year, from: .now)
    @State private var selectedMonth = Calendar.current.component(.month, from: .now)

    private var selectedDate: Date {
        return Calendar.current.date(from: DateComponents(year: selectedYear, month: selectedMonth, day: 1)) ?? .now
    }

    private var availableYears: [Int] {
        Array((2020...(Calendar.current.component(.year, from: .now) + 1)).reversed())
    }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    Picker("Person", selection: $selectedPerson) {
                        ForEach(Person.allCases) { person in
                            Text(store.name(for: person)).tag(person)
                        }
                    }
                    .pickerStyle(.segmented).padding(.vertical, 4)
                    Picker("Year", selection: $selectedYear) {
                        ForEach(availableYears, id: \.self) { year in Text(String(year)).tag(year) }
                    }
                    Picker("Month", selection: $selectedMonth) {
                        ForEach(1...12, id: \.self) { month in
                            Text(Calendar.current.monthSymbols[month - 1]).tag(month)
                        }
                    }
                }
                Section {
                    ForEach(store.expenses(for: selectedPerson, during: .month, relativeTo: selectedDate)) { expense in
                        HStack(spacing: 12) {
                            Image(systemName: expense.categorySymbol).foregroundStyle(selectedPerson.color).frame(width: 28)
                            VStack(alignment: .leading, spacing: 3) {
                                Text(expense.categoryName).font(.body.weight(.medium))
                                Text(expense.date, format: .dateTime.month(.abbreviated).day()).font(.caption).foregroundStyle(.secondary)
                            }
                            Spacer()
                            Text(expense.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                                .font(.body.weight(.semibold).monospacedDigit())
                        }.padding(.vertical, 3)
                    }
                } header: {
                    Text("\(store.name(for: selectedPerson))'s expenses \(Calendar.current.monthSymbols[selectedMonth - 1]) \(String(selectedYear))")
                } footer: {
                    HStack { Text("Total"); Spacer(); Text(store.total(for: selectedPerson, during: .month, relativeTo: selectedDate), format: .currency(code: Locale.current.currency?.identifier ?? "USD")) }
                        .font(.headline)
                }
            }
            .navigationTitle("Expense details")
        }
    }
}

private struct PeopleView: View {
    @EnvironmentObject private var store: ExpenseStore
    @State private var editingPerson: Person?

    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(Person.allCases) { person in
                        HStack(spacing: 12) {
                            PersonAvatar(person: person, size: 36)
                            Text(store.name(for: person))
                            Spacer()
                            Button("Edit") { editingPerson = person }
                                .buttonStyle(.bordered)
                        }
                    }
                } header: {
                    Text("People")
                } footer: {
                    Text("Names are saved on this device.")
                }
            }
            .navigationTitle("People")
            .sheet(item: $editingPerson) { person in
                EditPersonNameView(person: person).environmentObject(store)
            }
        }
    }
}

private struct EditPersonNameView: View {
    @EnvironmentObject private var store: ExpenseStore
    @Environment(\.dismiss) private var dismiss
    let person: Person
    @State private var name = ""
    @State private var selectedPhoto: PhotosPickerItem?

    var body: some View {
        NavigationStack {
            Form {
                Section("Photo") {
                    HStack {
                        PersonAvatar(person: person, size: 72)
                        Spacer()
                        PhotosPicker("Choose photo", selection: $selectedPhoto, matching: .images)
                    }
                }
                Section("Name") {
                    TextField("Name", text: $name)
                        .textInputAutocapitalization(.words)
                        .submitLabel(.done)
                }
            }
            .navigationTitle("Edit person")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear { name = store.name(for: person) }
            .onChange(of: selectedPhoto) { _, newPhoto in
                Task {
                    guard let newPhoto,
                          let imageData = try? await newPhoto.loadTransferable(type: Data.self) else { return }
                    store.setImage(imageData, for: person)
                }
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        store.setName(name, for: person)
                        dismiss()
                    }
                    .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
}

private struct CategoriesView: View {
    @EnvironmentObject private var store: ExpenseStore
    @State private var showingAddCategory = false
    @State private var editingCategory: ExpenseCategoryRecord?

    var body: some View {
        NavigationStack {
            List {
                ForEach(store.categories, id: \.id) { category in
                    HStack {
                        Image(systemName: category.symbol)
                            .foregroundStyle(.indigo)
                            .frame(width: 28)
                        Text(category.name)
                        Spacer()
                        Button("Edit") { editingCategory = category }
                            .buttonStyle(.bordered)
                    }
                }
                .onDelete { offsets in
                    for index in offsets { store.deleteCategory(store.categories[index]) }
                }
            }
            .navigationTitle("Expense items")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) { EditButton() }
                ToolbarItem(placement: .topBarTrailing) {
                    Button { showingAddCategory = true } label: { Image(systemName: "plus") }
                        .accessibilityLabel("Add expense item")
                }
            }
            .sheet(isPresented: $showingAddCategory) { EditCategoryView().environmentObject(store) }
            .sheet(item: $editingCategory) { category in EditCategoryView(category: category).environmentObject(store) }
        }
    }
}

private struct EditCategoryView: View {
    @EnvironmentObject private var store: ExpenseStore
    @Environment(\.dismiss) private var dismiss
    let category: ExpenseCategoryRecord?
    @State private var name = ""

    init(category: ExpenseCategoryRecord? = nil) {
        self.category = category
        _name = State(initialValue: category?.name ?? "")
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Item name") {
                    TextField("e.g. Gym", text: $name)
                        .textInputAutocapitalization(.words)
                        .submitLabel(.done)
                }
            }
            .navigationTitle(category == nil ? "New item" : "Edit item")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        if let category {
                            store.renameCategory(category, to: name)
                        } else {
                            store.addCategory(name: name)
                        }
                        dismiss()
                    }
                    .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
}

private struct AddExpenseView: View {
    @EnvironmentObject private var store: ExpenseStore
    @Environment(\.dismiss) private var dismiss
    @State private var person: Person = .alex
    @State private var categoryID: UUID?
    @State private var amount = ""
    @State private var date = Date.now

    private var parsedAmount: Double? { Double(amount.replacingOccurrences(of: ",", with: ".")) }

    var body: some View {
        NavigationStack {
            Form {
                Section("Who paid?") {
                    Picker("Person", selection: $person) {
                        ForEach(Person.allCases) { person in
                            Text(store.name(for: person)).tag(person)
                        }
                    }.pickerStyle(.segmented)
                }
                Section("Expense") {
                    Picker("Category", selection: $categoryID) {
                        ForEach(store.categories, id: \.id) { category in
                            Label(category.name, systemImage: category.symbol).tag(Optional(category.id))
                        }
                    }
                    TextField("Amount", text: $amount).keyboardType(.decimalPad)
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                }
            }
            .navigationTitle("New expense").navigationBarTitleDisplayMode(.inline)
            .onAppear {
                if categoryID == nil { categoryID = store.categories.first?.id }
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        guard let parsedAmount, parsedAmount > 0,
                              let categoryID,
                              let category = store.categories.first(where: { $0.id == categoryID }) else { return }
                        store.add(person: person, categoryName: category.name, categorySymbol: category.symbol, amount: parsedAmount, date: date)
                        dismiss()
                    }.disabled(parsedAmount == nil || parsedAmount ?? 0 <= 0 || categoryID == nil)
                }
            }
        }
    }
}

#Preview { ContentView() }
