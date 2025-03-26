//
//  EditPersonView.swift
//  RealTrack
//
//  Created by Robert Williams on 3/25/25.
//

import SwiftUI
import SwiftData

struct EditPersonView: View {
    let person: PersonModel

    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    @Query private var personTypes: [PersonTypeModel]

    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var mobilePhone: String = ""
    @State private var workPhone: String = ""
    @State private var selectedType: PersonTypeModel?
    @State private var selectedAddress: AddressModel?
    @State private var isAddingAddress = false

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Name")) {
                    TextField("First Name", text: $firstName)
                    TextField("Last Name", text: $lastName)
                }

                Section(header: Text("Contact")) {
                    TextField("Mobile Phone", text: $mobilePhone)
                        .keyboardType(.numberPad)
                        .onChange(of: mobilePhone) { mobilePhone = formatPhone(mobilePhone) }

                    TextField("Work Phone", text: $workPhone)
                        .keyboardType(.numberPad)
                        .onChange(of: workPhone) { workPhone = formatPhone(workPhone) }
                }

                Section(header: Text("Person Type")) {
                    Picker("Select Type", selection: $selectedType) {
                        ForEach(personTypes) { type in
                            Text(type.name ?? "Unknown")
                                .tag(type as PersonTypeModel?)
                        }
                    }
                }

                addressListSection()
            }
            .navigationTitle("Edit Person")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.red)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        saveChanges()
                    }
                    .disabled(firstName.isEmpty || selectedType == nil)
                }
            }
            .onAppear {
                firstName = person.firstName ?? ""
                lastName = person.lastName ?? ""
                mobilePhone = person.mobilePhone ?? ""
                workPhone = person.workPhone ?? ""
                selectedType = person.personType
            }
            .sheet(item: $selectedAddress) { address in
                EditAddressView(address: address)
            }
            .sheet(isPresented: $isAddingAddress) {
                AddAddressView(person: person)
            }
        }
    }

    private func saveChanges() {
        person.firstName = firstName
        person.lastName = lastName
        person.mobilePhone = mobilePhone
        person.workPhone = workPhone
        person.personType = selectedType

        do {
            try context.save()
            dismiss()
        } catch {
            print("❌ Error saving person: \(error)")
        }
    }

    @ViewBuilder
    private func addressListSection() -> some View {
        Section(header: Text("Addresses")) {
            if person.addresses.isEmpty {
                Text("No addresses on file.")
                    .foregroundStyle(.secondary)
            } else {
                ForEach(person.addresses, id: \.id) { address in
                    VStack(alignment: .leading, spacing: 4) {
                        if let label = address.addressType?.name {
                            Text(label)
                                .font(.subheadline)
                                .bold()
                        }
                        if let line1 = address.address1 { Text(line1) }
                        if let line2 = address.address2 { Text(line2) }
                        HStack {
                            Text(address.city ?? "")
                            Text(address.state ?? "")
                            Text(address.zip ?? "")
                        }
                        .font(.caption)
                        .foregroundStyle(.secondary)

                        Button("Edit") {
                            selectedAddress = address
                        }
                        .font(.caption)
                    }
                    .padding(.vertical, 4)
                }
            }

            Button {
                isAddingAddress = true
            } label: {
                Label("New Address", systemImage: "plus")
            }
        }
    }
}

#Preview {
    do {
        let container = try ModelContainer(
            for: Schema([
                PersonModel.self,
                PersonTypeModel.self,
                AddressModel.self,
                AddressTypeModel.self
            ]),
            configurations: [ModelConfiguration(isStoredInMemoryOnly: true)]
        )

        let personType = PersonTypeModel(name: "Owner")
        let addressType = AddressTypeModel(name: "Home")

        let person = PersonModel(
            firstName: "Jane",
            lastName: "Doe",
            mobilePhone: "1234567890",
            workPhone: "9876543210",
            ein: nil,
            ssn: nil,
            personType: personType
        )

        let address = AddressModel(
            address1: "123 Main St",
            address2: "Apt 4B",
            city: "New York",
            state: "NY",
            zip: "10001"
        )
        address.person = person
        address.addressType = addressType

        container.mainContext.insert(personType)
        container.mainContext.insert(addressType)
        container.mainContext.insert(person)
        container.mainContext.insert(address)

        return NavigationStack {
            EditPersonView(person: person)
        }
        .modelContainer(container)
    } catch {
        fatalError("❌ Failed to create preview container: \(error)")
    }
}
