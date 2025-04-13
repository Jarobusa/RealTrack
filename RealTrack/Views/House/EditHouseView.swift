//
//  EditHouseView.swift
//  RealTrack
//
//  Created by Robert Williams on 4/12/25.
//

import SwiftUI

struct EditHouseView: View {
    @ObservedObject var house: HouseEntity

    var body: some View {
        Form {
            Section(header: Text("House Details")) {
                TextField("Name", text: Binding(
                    get: { house.name ?? "" },
                    set: { house.name = $0 }
                ))
            }

            if let address = house.address {
                Section(header: Text("Address")) {
                    Text(address.address1 ?? "")
                    Text("\(String(describing: address.city)), \(String(describing: address.state)) \(String(describing: address.zipCode))")
                }
            }
        }
        .navigationTitle("Edit House")
    }
}
