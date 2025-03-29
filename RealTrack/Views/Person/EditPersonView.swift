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
    @State private var email: String = ""
    @State private var selectedType: PersonTypeModel?
    @State private var isAddingAddress = false
    @State private var showInvalidEmailWarning = false
    @State private var hasChanges: Bool = false
    @State private var isInitialized = false
    
    enum EditingAddressType: Identifiable {
        case home, work
 
        var id: String {
            switch self {
            case .home: return "home"
            case .work: return "work"
            }
        }
    }
    @State private var editingAddressType: EditingAddressType?

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Name")) {
                    TextField("First Name", text: $firstName)
                        .onChange(of: firstName) {
                            if isInitialized { hasChanges = true }
                        }
                    TextField("Last Name", text: $lastName)
                        .onChange(of: lastName) {
                            if isInitialized { hasChanges = true }
                        }
                }

                Section(header: Text("Contact")) {
                    TextField("Mobile Phone", text: $mobilePhone)
                        .keyboardType(.numberPad)
                        .onChange(of: mobilePhone) { mobilePhone = formatPhone(mobilePhone) }
                        .onChange(of: mobilePhone) {
                            if isInitialized { hasChanges = true }
                        }

                    TextField("Work Phone", text: $workPhone)
                        .keyboardType(.numberPad)
                        .onChange(of: workPhone) { workPhone = formatPhone(workPhone) }
                        .onChange(of: workPhone) {
                            if isInitialized { hasChanges = true }
                        }
                    
                    TextField("Email", text: $email)
                        .onChange(of: email) {
                            email = email.lowercased()
                            showInvalidEmailWarning = !email.isEmpty && !isValidEmail(email)
                        }
                        .onChange(of: email) {
                            if isInitialized { hasChanges = true }
                        }
                    
                    if showInvalidEmailWarning {
                        Text("Please enter a valid email address.")
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                }

                Section(header: Text("Person Type")) {
                    Picker("Select Type", selection: $selectedType) {
                        ForEach(personTypes) { type in
                            Text(type.name ?? "Unknown")
                                .tag(type as PersonTypeModel?)
                        }
                    }
                    .onChange(of: selectedType) {
                        if isInitialized { hasChanges = true }
                    }
                }

                Section(header: Text("Home Address")) {
                    if let home = person.homeAddress {
                        VStack(alignment: .leading) {
                            if let line1 = home.address1 { Text(line1) }
                            if let line2 = home.address2 { Text(line2) }
                            HStack {
                                Text(home.city ?? "")
                                Text(home.state ?? "")
                                Text(home.zip ?? "")
                            }
                            .font(.caption)
                            .foregroundStyle(.secondary)

                            Button("Edit") {
                                editingAddressType = .home
                            }
                            .font(.caption)
                        }
                    } else {
                        Text("No home address.")
                        Button("Add Home Address") {
                            person.homeAddress = AddressModel()
                            editingAddressType = .home
                        }
                    }
                }

                Section(header: Text("Work Address")) {
                    if let work = person.workAddress {
                        VStack(alignment: .leading) {
                            if let line1 = work.address1 { Text(line1) }
                            if let line2 = work.address2 { Text(line2) }
                            HStack {
                                Text(work.city ?? "")
                                Text(work.state ?? "")
                                Text(work.zip ?? "")
                            }
                            .font(.caption)
                            .foregroundStyle(.secondary)

                            Button("Edit") {
                                editingAddressType = .work
                            }
                            .font(.caption)
                        }
                    } else {
                        Text("No work address.")
                        Button("Add Work Address") {
                            person.workAddress = AddressModel()
                            editingAddressType = .work
                        }
                    }
                }
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
                    .disabled(
                        firstName.isEmpty ||
                        selectedType == nil ||
                        !hasChanges ||
                        (!email.isEmpty && !isValidEmail(email))
                    )
                }
            }
            .onAppear {
                isInitialized = false
                firstName = person.firstName ?? ""
                lastName = person.lastName ?? ""
                mobilePhone = person.mobilePhone ?? ""
                workPhone = person.workPhone ?? ""
                email = person.email ?? ""
                selectedType = person.personType
                hasChanges = false
                isInitialized = true
            }
            .sheet(item: $editingAddressType) { type in
                if let address = (type == .home ? person.homeAddress : person.workAddress) {
                    EditAddressView(address: address)
                }
            }
            .sheet(isPresented: $isAddingAddress) {
                AddAddressView(person: person)
            }
        }
    }

    private func saveChanges() {
        guard email.isEmpty || isValidEmail(email) else {
            showInvalidEmailWarning = true
            return
        }
        showInvalidEmailWarning = false

        person.firstName = firstName
        person.lastName = lastName
        person.mobilePhone = mobilePhone
        person.workPhone = workPhone
        person.email = email
        person.personType = selectedType

        do {
            try context.save()
            hasChanges = false
            dismiss()
        } catch {
            print("❌ Error saving person: \(error)")
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
            email: "jane@example.com",
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
