//
//  EditHouse.swift
//  RealTrack
//
//  Created by Robert Williams on 4/4/25.
//

import SwiftUI
import SwiftData

struct EditHouse: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context

    // Local state variables for editing the house details
    @State private var houseName: String
    @State private var address1: String
    @State private var address2: String
    @State private var city: String
    @State private var state: String
    @State private var zip: String

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
        Form {
            Section(header: Text("House Details")) {
                TextField("House Name", text: $houseName)
            }

            Section(header: Text("Address")) {
                TextField("Address Line 1", text: $address1)
                TextField("Address Line 2", text: $address2)
                TextField("City", text: $city)
                TextField("State", text: $state)
                TextField("Zip", text: $zip)
            }
        }
        .navigationTitle("Edit House")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cancel") {
                    dismiss()
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
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
        }
    }
}
