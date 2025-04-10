//
//  EditHouseView.swift
//  RealTrack
//
//  Created by Robert Williams on 4/4/25.
//

import SwiftUI
import SwiftData

struct EditHouseView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context

    // Local state variables for editing the house details
    @State private var houseName: String
    @State private var address1: String
    @State private var address2: String
    @State private var city: String
    @State private var state: String
    @State private var zip: String
    @State private var showAddAssociationSheet = false

    // The house being edited
    var house: HouseModel

    // Initialize state from the passed in house
    init(house: HouseModel) {
        self.house = house
        _houseName = State(initialValue: house.name ?? "")
        _address1 = State(initialValue: house.address.address1 ?? "")
        _address2 = State(initialValue: house.address.address2 ?? "")
        _city = State(initialValue: house.address.city ?? "")
        _state = State(initialValue: house.address.state ?? "")
        _zip = State(initialValue: house.address.zip ?? "")
    }

    var body: some View {
        FormContent
            .navigationTitle("Edit House")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                leadingToolbarItems
                trailingToolbarItems
            }
            .sheet(isPresented: $showAddAssociationSheet) {
                SelectPersonAssociationView { selectedPerson in
                    let newAssociation = HouseAssociationModel(house: house, person: selectedPerson, isActive: true, role: nil)
                    house.associations.append(newAssociation)
                    context.insert(newAssociation)
                }
            }
    }
    
    private var FormContent: some View {
        Form {
            houseDetailsSection
            addressSection
            associationsSection
        }
    }
    
    private var houseDetailsSection: some View {
        Section(header: Text("House Details")) {
            TextField("House Name", text: $houseName)
        }
    }
    
    private var addressSection: some View {
        Section(header: Text("Address")) {
            TextField("Address Line 1", text: $address1)
            TextField("Address Line 2", text: $address2)
            TextField("City", text: $city)
            TextField("State", text: $state)
            TextField("Zip", text: $zip)
        }
    }
    
    private var associationsSection: some View {
        Section(header: Text("Associations")) {
            if house.associations.isEmpty {
                Text("No associations yet.")
                    .foregroundColor(.secondary)
            } else {
                ForEach(house.associations, id: \.id) { association in
                    AssociationRow(association: association)
                }
            }
            Button("Add Association") {
                showAddAssociationSheet = true
            }
        }
    }
    
    private var leadingToolbarItems: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button("Cancel") {
                dismiss()
            }
        }
    }
    
    private var trailingToolbarItems: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button("Save") {
                saveHouse()
            }
        }
    }
    
    private func saveHouse() {
        // Update the house model with edited values
        house.name = houseName
        house.address.address1 = address1
        house.address.address2 = address2.isEmpty ? nil : address2
        house.address.city = city
        house.address.state = state
        house.address.zip = zip

        // Save changes via the model context
        do {
            try context.save()
            dismiss()
        } catch {
            print("Error saving house: \(error)")
        }
    }
}

struct AssociationRow: View {
    let association: HouseAssociationModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(association.person?.firstName ?? "") \(association.person?.lastName ?? "")")
                .font(.headline)
            if let role = association.role, !role.isEmpty {
                Text("Role: \(role)")
                    .font(.subheadline)
            }
        }
        .padding(.vertical, 4)
    }
}

struct SelectPersonAssociationView: View {
    @Environment(\.dismiss) private var dismiss
    @Query private var persons: [PersonModel]
    
    var onSelect: (PersonModel) -> Void
    
    var body: some View {
        NavigationStack {
            List(persons, id: \.id) { person in
                Button {
                    onSelect(person)
                    dismiss()
                } label: {
                    VStack(alignment: .leading) {
                        Text("\(person.firstName ?? "") \(person.lastName ?? "")")
                            .font(.headline)
                        if let typeName = person.personType?.name {
                            Text("Type: \(typeName)")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("Select Person")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}
