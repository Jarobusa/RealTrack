//
//  PersonView.swift
//  RealTrack
//
//  Created by Robert Williams on 3/23/25.
//

import SwiftUI
import SwiftData

struct PersonsView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \PersonModel.firstName) private var people: [PersonModel]

    @State private var showingAddPerson = false

    var body: some View {
        NavigationStack {
            List(people, id: \.id) { person in
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
            .navigationTitle("People")
            .toolbar {
                Button {
                    showingAddPerson = true
                } label: {
                    Label("Add Person", systemImage: "plus")
                }
            }
            .sheet(isPresented: $showingAddPerson) {
                AddPersonView()
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

    return PersonsView()
        .modelContainer(container)
}
