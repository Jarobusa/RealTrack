//
//  AddAddressView.swift
//  RealTrack
//
//  Created by Robert Williams on 3/7/25.
//

import SwiftUI
import SwiftData

struct AddAddressView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    var viewModel: AddressViewModel? = nil
    var person: PersonModel? = nil

    @Query private var addressTypes: [AddressTypeModel]

    @State private var address1: String = ""
    @State private var address2: String = ""
    @State private var city: String = ""
    @State private var state: String = ""
    @State private var zip: String = ""
    @State private var selectedType: AddressTypeModel?

    @FocusState private var isAddress1Focused: Bool

    private var isSaveEnabled: Bool {
        !address1.trimmingCharacters(in: .whitespaces).isEmpty &&
        !city.trimmingCharacters(in: .whitespaces).isEmpty &&
        !state.trimmingCharacters(in: .whitespaces).isEmpty &&
        !zip.trimmingCharacters(in: .whitespaces).isEmpty &&
        selectedType != nil
    }

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Address Details")) {
                    TextField("Address 1", text: $address1, prompt: Text("123 Main St").foregroundColor(.gray))
                        .focused($isAddress1Focused)

                    TextField("Address 2", text: $address2, prompt: Text("Apt 4B").foregroundColor(.gray))

                    TextField("City", text: $city, prompt: Text("Atlanta").foregroundColor(.gray))

                    TextField("State", text: $state, prompt: Text("GA").foregroundColor(.gray))

                    TextField("Zip Code", text: $zip, prompt: Text("30310").foregroundColor(.gray))
                        .keyboardType(.numberPad)
                }

                Section(header: Text("Address Type")) {
                    Picker("Select Type", selection: $selectedType) {
                        ForEach(addressTypes) { type in
                            Text(type.name ?? "Unknown").tag(type as AddressTypeModel?)
                        }
                    }
                    .pickerStyle(.menu)
                }
            }
            .navigationTitle("Add Address")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.red)
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        saveAddress()
                    }
                    .disabled(!isSaveEnabled)
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    isAddress1Focused = true
                }
                selectedType = addressTypes.first
            }
        }
    }

    private func saveAddress() {
        let newAddress = AddressModel(
            id: UUID(),
            address1: address1,
            address2: address2.isEmpty ? nil : address2,
            city: city,
            state: state,
            zip: zip,
            timestamp: Date()
        )

        if let person {
            newAddress.person = person
        }

        newAddress.addressType = selectedType

        modelContext.insert(newAddress)

        do {
            try modelContext.save()
            viewModel?.fetchAddresses()
            dismiss()
        } catch {
            print("❌ Error saving address: \(error)")
        }
    }
}
