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
    @Query private var addressTypes: [AddressTypeModel]

    @State private var firstName = ""
    @State private var lastName = ""
    @State private var mobilePhone = ""
    @State private var workPhone = ""
    @State private var ein = ""
    @State private var ssn = ""
    @State private var selectedType: PersonTypeModel?
    @State private var selectedAddressType: AddressTypeModel?
    @State private var address1 = ""
    @State private var address2 = ""
    @State private var city = ""
    @State private var state = ""
    @State private var zip = ""

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

                Section(header: Text("Address")) {
                    Picker("Address Type", selection: $selectedAddressType) {
                        ForEach(addressTypes) { type in
                            Text(type.name ?? "Unnamed").tag(type as AddressTypeModel?)
                        }
                    }
                    .pickerStyle(.menu)

                    TextField("Address 1", text: $address1)
                    TextField("Address 2", text: $address2)
                    TextField("City", text: $city)
                    TextField("State", text: $state)
                    TextField("Zip", text: $zip)
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
                if selectedAddressType == nil {
                    selectedAddressType = addressTypes.first
                }
            }
        }
    }

    private func savePerson() {
        let address = AddressModel(
            address1: address1.isEmpty ? nil : address1,
            address2: address2.isEmpty ? nil : address2,
            city: city.isEmpty ? nil : city,
            state: state.isEmpty ? nil : state,
            zip: zip.isEmpty ? nil : zip,
            addressType: selectedAddressType!,
            timestamp: .now
        )

        viewModel.addPerson(
            firstName: firstName,
            lastName: lastName.isEmpty ? nil : lastName,
            mobilePhone: mobilePhone.isEmpty ? nil : mobilePhone,
            workPhone: workPhone.isEmpty ? nil : workPhone,
            ein: ein.isEmpty ? nil : ein,
            ssn: ssn.isEmpty ? nil : ssn,
            personType: selectedType!,
            address: address
        )
        dismiss()
    }
}
