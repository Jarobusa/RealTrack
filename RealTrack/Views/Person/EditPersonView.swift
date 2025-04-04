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
    @State private var showInvalidEmailWarning = false
    @State private var hasChanges: Bool = false
    @State private var isInitialized = false

    @State private var homeAddress1 = ""
    @State private var homeAddress2 = ""
    @State private var homeCity = ""
    @State private var homeState = ""
    @State private var homeZip = ""

    @State private var workAddress1 = ""
    @State private var workAddress2 = ""
    @State private var workCity = ""
    @State private var workState = ""
    @State private var workZip = ""

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
                    TextField("Address 1", text: $homeAddress1)
                    TextField("Address 2", text: $homeAddress2)
                    TextField("City", text: $homeCity)
                    TextField("State", text: $homeState)
                    TextField("Zip", text: $homeZip)
                    
                    if person.homeAddress != nil {
                        Button("Remove Home Address", role: .destructive) {
                            person.homeAddress = nil
                            homeAddress1 = ""
                            homeAddress2 = ""
                            homeCity = ""
                            homeState = ""
                            homeZip = ""
                            hasChanges = true
                        }
                    }
                }

                Section(header: Text("Work Address")) {
                    TextField("Address 1", text: $workAddress1)
                    TextField("Address 2", text: $workAddress2)
                    TextField("City", text: $workCity)
                    TextField("State", text: $workState)
                    TextField("Zip", text: $workZip)
                    
                    if person.workAddress != nil {
                        Button("Remove Work Address", role: .destructive) {
                            person.workAddress = nil
                            workAddress1 = ""
                            workAddress2 = ""
                            workCity = ""
                            workState = ""
                            workZip = ""
                            hasChanges = true
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
                
                if let home = person.homeAddress {
                    homeAddress1 = home.address1 ?? ""
                    homeAddress2 = home.address2 ?? ""
                    homeCity = home.city ?? ""
                    homeState = home.state ?? ""
                    homeZip = home.zip ?? ""
                }
                
                if let work = person.workAddress {
                    workAddress1 = work.address1 ?? ""
                    workAddress2 = work.address2 ?? ""
                    workCity = work.city ?? ""
                    workState = work.state ?? ""
                    workZip = work.zip ?? ""
                }
                
                hasChanges = false
                isInitialized = true
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
        person.mobilePhone = mobilePhone.isEmpty ? nil : mobilePhone
        person.workPhone = workPhone.isEmpty ? nil : workPhone
        person.email = email.isEmpty ? nil : email
        person.personType = selectedType

        // HOME
        let hasHomeData = [homeAddress1, homeAddress2, homeCity, homeState, homeZip].contains { !$0.isEmpty }
        if hasHomeData {
            if let existingHome = person.homeAddress {
                existingHome.address1 = homeAddress1.isEmpty ? nil : homeAddress1
                existingHome.address2 = homeAddress2.isEmpty ? nil : homeAddress2
                existingHome.city = homeCity.isEmpty ? nil : homeCity
                existingHome.state = homeState.isEmpty ? nil : homeState
                existingHome.zip = homeZip.isEmpty ? nil : homeZip
                existingHome.timestamp = .now
            } else {
                person.homeAddress = AddressModel(
                    address1: homeAddress1.isEmpty ? nil : homeAddress1,
                    address2: homeAddress2.isEmpty ? nil : homeAddress2,
                    city: homeCity.isEmpty ? nil : homeCity,
                    state: homeState.isEmpty ? nil : homeState,
                    zip: homeZip.isEmpty ? nil : homeZip,
                    timestamp: .now
                )
            }
        }

        // WORK
        let hasWorkData = [workAddress1, workAddress2, workCity, workState, workZip].contains { !$0.isEmpty }
        if hasWorkData {
            if let existingWork = person.workAddress {
                existingWork.address1 = workAddress1.isEmpty ? nil : workAddress1
                existingWork.address2 = workAddress2.isEmpty ? nil : workAddress2
                existingWork.city = workCity.isEmpty ? nil : workCity
                existingWork.state = workState.isEmpty ? nil : workState
                existingWork.zip = workZip.isEmpty ? nil : workZip
                existingWork.timestamp = .now
            } else {
                person.workAddress = AddressModel(
                    address1: workAddress1.isEmpty ? nil : workAddress1,
                    address2: workAddress2.isEmpty ? nil : workAddress2,
                    city: workCity.isEmpty ? nil : workCity,
                    state: workState.isEmpty ? nil : workState,
                    zip: workZip.isEmpty ? nil : workZip,
                    timestamp: .now
                )
            }
        }

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
            ]),
            configurations: [ModelConfiguration(isStoredInMemoryOnly: true)]
        )

        let personType = PersonTypeModel(name: "Owner")
    
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
