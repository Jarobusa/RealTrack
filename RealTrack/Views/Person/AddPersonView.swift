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
    @ObservedObject var viewModel: PersonViewModel
    @Query private var personTypes: [PersonTypeModel]

    @State private var firstName = ""
    @State private var lastName = ""
    @State private var mobilePhone = ""
    @State private var workPhone = ""
    @State private var ein = ""
    @State private var ssn = ""
    @State private var selectedType: PersonTypeModel?

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Name")) {
                    TextField("First Name", text: $firstName)
                    TextField("Last Name", text: $lastName)
                }

                Section(header: Text("Contact")) {
                    TextField("Mobile Phone", text: $mobilePhone)
                        .keyboardType(.numberPad)
                        .onChange(of: mobilePhone) {
                            mobilePhone = formatPhone(mobilePhone)
                        }

                    TextField("Work Phone", text: $workPhone)
                        .keyboardType(.numberPad)
                        .onChange(of: workPhone) {
                            workPhone = formatPhone(workPhone)
                        }
                }

                Section(header: Text("Person Type")) {
                    Picker("Select Type", selection: $selectedType) {
                        ForEach(personTypes) { type in
                            Text(type.name ?? "Unnamed").tag(type as PersonTypeModel?)
                        }
                    }
                    .pickerStyle(.menu)
                }

                Section(header: Text("Identifiers")) {
                    TextField("EIN (##-#######)", text: $ein)
                        .keyboardType(.numberPad)
                        .onChange(of: ein) {
                            ein = formatEIN(ein)
                        }

                    TextField("SSN (###-##-####)", text: $ssn)
                        .keyboardType(.numberPad)
                        .onChange(of: ssn) {
                            ssn = formatSSN(ssn)
                        }
                }
            }
            .navigationTitle("Add Person")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        savePerson()
                    }
                    .disabled(firstName.isEmpty || selectedType == nil)
                }
            }
            .onAppear {
                if selectedType == nil {
                    selectedType = personTypes.first
                }
            }
        }
    }

    private func savePerson() {
        viewModel.addPerson(
            firstName: firstName,
            lastName: lastName.isEmpty ? nil : lastName,
            mobilePhone: mobilePhone.isEmpty ? nil : mobilePhone,
            workPhone: workPhone.isEmpty ? nil : workPhone,
            ein: ein.isEmpty ? nil : ein,
            ssn: ssn.isEmpty ? nil : ssn,
            personType: selectedType!
        )
        dismiss()
    }
}
