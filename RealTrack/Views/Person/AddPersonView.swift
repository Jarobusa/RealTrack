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

    @State private var firstName = ""
    @State private var lastName = ""
    @State private var mobilePhone = ""
    @State private var workPhone = ""
    @State private var ein = ""
    @State private var ssn = ""
    @State private var selectedKind: AddressKind = .home

    @State private var showHomeAddress = true
    @State private var showWorkAddress = false

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

    enum AddressKind: String, CaseIterable, Identifiable {
        case home = "Home"
        case work = "Work"
        var id: String { rawValue }
    }

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
                        .onChange(of: mobilePhone) { oldValue, newValue in
                            if newValue.count > oldValue.count {
                                mobilePhone = formatPhone(newValue)
                            }
                        }

                    TextField("Work Phone", text: $workPhone)
                        .keyboardType(.numberPad)
                        .onChange(of: workPhone) { oldValue, newValue in
                            if newValue.count > oldValue.count {
                                workPhone = formatPhone(newValue)
                            }
                        }
                }

                Section(header: Text("Address")) {
                    DisclosureGroup("Home Address", isExpanded: $showHomeAddress) {
                        TextField("Address 1", text: $homeAddress1)
                        TextField("Address 2", text: $homeAddress2)
                        TextField("City", text: $homeCity)
                        TextField("State", text: $homeState)
                        TextField("Zip", text: $homeZip)
                    }

                    DisclosureGroup("Work Address", isExpanded: $showWorkAddress) {
                        TextField("Address 1", text: $workAddress1)
                        TextField("Address 2", text: $workAddress2)
                        TextField("City", text: $workCity)
                        TextField("State", text: $workState)
                        TextField("Zip", text: $workZip)
                    }
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
                    .disabled(firstName.isEmpty)
                }
            }
          
        }
    }

    private func savePerson() {
        let homeAddress: AddressModel? = homeAddress1.isEmpty ? nil : AddressModel(
            address1: homeAddress1,
            address2: homeAddress2.isEmpty ? nil : homeAddress2,
            city: homeCity.isEmpty ? nil : homeCity,
            state: homeState.isEmpty ? nil : homeState,
            zip: homeZip.isEmpty ? nil : homeZip,
            timestamp: .now
        )

        let workAddress: AddressModel? = workAddress1.isEmpty ? nil : AddressModel(
            address1: workAddress1,
            address2: workAddress2.isEmpty ? nil : workAddress2,
            city: workCity.isEmpty ? nil : workCity,
            state: workState.isEmpty ? nil : workState,
            zip: workZip.isEmpty ? nil : workZip,
            timestamp: .now
        )

        viewModel.addPerson(
            firstName: firstName,
            lastName: lastName.isEmpty ? nil : lastName,
            mobilePhone: mobilePhone.isEmpty ? nil : mobilePhone,
            workPhone: workPhone.isEmpty ? nil : workPhone,
            ein: ein.isEmpty ? nil : ein,
            ssn: ssn.isEmpty ? nil : ssn,
            homeAddress: showHomeAddress ? homeAddress : nil,
            workAddress: showWorkAddress ? workAddress : nil
        )
        dismiss()
    }
}
