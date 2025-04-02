//
//  AddHouseView.swift
//  RealTrack
//
//  Created by Robert Williams on 4/1/25.
//

import SwiftUI
import SwiftData

struct AddHouseView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @State private var houseName: String = ""
    @State private var address1: String = ""
    @State private var address2: String = ""
    @State private var city: String = ""
    @State private var state: String = ""
    @State private var zip: String = ""

    @FocusState private var isHouseNameFocused: Bool

    private var isSaveEnabled: Bool {
        !houseName.trimmingCharacters(in: .whitespaces).isEmpty &&
        !address1.trimmingCharacters(in: .whitespaces).isEmpty &&
        !city.trimmingCharacters(in: .whitespaces).isEmpty &&
        !state.trimmingCharacters(in: .whitespaces).isEmpty &&
        !zip.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("House Details")) {
                    TextField("House Name", text: $houseName, prompt: Text("Enter house name").foregroundColor(.gray))
                        .focused($isHouseNameFocused)
                }
                Section(header: Text("Address Details")) {
                    TextField("Address 1", text: $address1, prompt: Text("123 Main St").foregroundColor(.gray))
                    TextField("Address 2", text: $address2, prompt: Text("Apt 4B").foregroundColor(.gray))
                    TextField("City", text: $city, prompt: Text("City").foregroundColor(.gray))
                    TextField("State", text: $state, prompt: Text("State").foregroundColor(.gray))
                    TextField("Zip Code", text: $zip, prompt: Text("Zip Code").foregroundColor(.gray))
                        .keyboardType(.numberPad)
                }
            }
            .navigationTitle("Add House")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.red)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        saveHouse()
                    } label: {
                        Image(systemName: "plus")
                    }
                    .disabled(!isSaveEnabled)
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    isHouseNameFocused = true
                }
            }
        }
    }

    private func saveHouse() {
        let newAddress = AddressModel(
            id: UUID(),
            address1: address1,
            address2: address2.isEmpty ? nil : address2,
            city: city,
            state: state,
            zip: zip,
            timestamp: Date()
        )
        modelContext.insert(newAddress)

        let newHouse = HouseModel(
            id: UUID(),
            name: houseName,
            address: newAddress,
            timestamp: Date()
        )
        modelContext.insert(newHouse)

        do {
            try modelContext.save()
            dismiss()
        } catch {
            print("❌ Error saving house: \(error)")
        }
    }
}

struct AddHouseView_Previews: PreviewProvider {
    static var previews: some View {
        AddHouseView()
    }
}
