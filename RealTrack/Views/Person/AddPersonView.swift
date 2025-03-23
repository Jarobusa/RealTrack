//
//  AddPersonView.swift
//  RealTrack
//
//  Created by Robert Williams on 3/23/25.
//

import SwiftUI
import SwiftData

struct AddPersonView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    @Query(sort: \PersonTypeModel.name) private var personTypes: [PersonTypeModel]

    @State private var firstName = ""
    @State private var lastName = ""
    @State private var mobilePhone = ""
    @State private var workPhone = ""
    @State private var ein = ""
    @State private var ssn = ""
    @State private var selectedType: PersonTypeModel?

    var isEINValid: Bool {
        ein.isEmpty || ein.matches(#"^\d{2}-\d{7}$"#)
    }

    var isSSNValid: Bool {
        ssn.isEmpty || ssn.matches(#"^\d{3}-\d{2}-\d{4}$"#)
    }

    var canSave: Bool {
        !firstName.isEmpty && isEINValid && isSSNValid && selectedType != nil
    }

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Basic Info")) {
                    TextField("First Name *", text: $firstName)
                    TextField("Last Name", text: $lastName)
                }

                Section(header: Text("Phone Numbers")) {
                    TextField("Mobile Phone", text: $mobilePhone)
                    TextField("Work Phone", text: $workPhone)
                }

                Section(header: Text("Identifiers")) {
                    TextField("EIN (XX-XXXXXXX)", text: $ein)
                        .autocapitalization(.none)
                    if !isEINValid {
                        Text("Invalid EIN format").foregroundColor(.red)
                    }

                    TextField("SSN (XXX-XX-XXXX)", text: $ssn)
                        .autocapitalization(.none)
                    if !isSSNValid {
                        Text("Invalid SSN format").foregroundColor(.red)
                    }
                }

                Section(header: Text("Person Type")) {
                    Picker("Type", selection: $selectedType) {
                        ForEach(personTypes, id: \.id) { type in
                            Text(type.name ?? "Unnamed").tag(type as PersonTypeModel?)
                        }
                    }
                }
            }
            .navigationTitle("Add Person")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let newPerson = PersonModel(
                            firstName: firstName,
                            lastName: lastName.isEmpty ? nil : lastName,
                            mobilePhone: mobilePhone.isEmpty ? nil : mobilePhone,
                            workPhone: workPhone.isEmpty ? nil : workPhone,
                            ein: ein.isEmpty ? nil : ein,
                            ssn: ssn.isEmpty ? nil : ssn,
                            personType: selectedType!
                        )
                        context.insert(newPerson)
                        dismiss()
                    }
                    .disabled(!canSave)
                }

                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", role: .cancel) {
                        dismiss()
                    }
                }
            }
        }
    }
}


#Preview {
    let container = try! ModelContainer(for: PersonModel.self, PersonTypeModel.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))

    // Insert mock person types
    let employeeType = PersonTypeModel(name: "Employee")
    let contractorType = PersonTypeModel(name: "Contractor")

    container.mainContext.insert(employeeType)
    container.mainContext.insert(contractorType)

    return AddPersonView()
        .modelContainer(container)
}
