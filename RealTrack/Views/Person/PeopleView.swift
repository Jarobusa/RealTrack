//
//  PersonView.swift
//  RealTrack
//
//  Created by Robert Williams on 3/23/25.
//

import SwiftUI
import SwiftData

struct PeopleView: View {
    @Environment(\.modelContext) private var context
    @Query private var people: [PersonModel]

    @State private var showingAddPerson = false
    @State private var selectedSortOption: SortOption = .firstName

    enum SortOption: String, CaseIterable, Identifiable {
        case firstName = "First Name"
        case lastName = "Last Name"
        case personType = "Type"
        case state = "State"

        var id: String { self.rawValue }
    }

    var body: some View {
        NavigationStack {
            VStack {
                Picker("Sort by", selection: $selectedSortOption) {
                    ForEach(SortOption.allCases) { option in
                        Text(option.rawValue).tag(option)
                    }
                }
                .pickerStyle(.segmented)
                .padding()

                List(sortedPeople, id: \.id) { person in
                    NavigationLink(destination: PersonView(person: person)) {
                        VStack(alignment: .leading) {
                            Text("\(person.firstName ?? "") \(person.lastName ?? "")")
                                .font(.headline)
                            if let phone = person.mobilePhone?.formattedAsPhone {
                                Text("📱 \(phone)")
                            }
                            if let type = person.personType?.name {
                                Text("Type: \(type)")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
            }
            .navigationTitle("People")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingAddPerson = true
                    } label: {
                        Label("Add Person", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddPerson) {
                AddPersonView(viewModel: PersonViewModel(modelContext: context))
            }
        }
    }

    private var sortedPeople: [PersonModel] {
        switch selectedSortOption {
        case .firstName:
            return people.sorted { ($0.firstName ?? "") < ($1.firstName ?? "") }
        case .lastName:
            return people.sorted { ($0.lastName ?? "") < ($1.lastName ?? "") }
        case .personType:
            return people.sorted { ($0.personType?.name ?? "") < ($1.personType?.name ?? "") }
        case .state:
            return people.sorted {
                let s1 = $0.addresses.first?.state ?? ""
                let s2 = $1.addresses.first?.state ?? ""
                return s1 < s2
            }
        }
    }
}

#Preview {
    let container = try! ModelContainer(for: PersonModel.self, PersonTypeModel.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))

    // Create mock person type
    let type1 = PersonTypeModel(name: "Employee")
    let type2 = PersonTypeModel(name: "Contractor")

    // Insert mock data
    let person1 = PersonModel(
        firstName: "Alice",
        lastName: "Johnson",
        mobilePhone: "123-456-7890",
        workPhone: nil,
        ein: "12-3456789",
        ssn: "123-45-6789",
        personType: type1
    )

    let person2 = PersonModel(
        firstName: "Bob",
        lastName: "Smith",
        mobilePhone: nil,
        workPhone: "987-654-3210",
        ein: nil,
        ssn: nil,
        personType: type2
    )

    container.mainContext.insert(type1)
    container.mainContext.insert(type2)
    container.mainContext.insert(person1)
    container.mainContext.insert(person2)

    return PeopleView()
        .modelContainer(container)
}
