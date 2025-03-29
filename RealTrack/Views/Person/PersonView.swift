//
//  PersonView.swift
//  RealTrack
//
//  Created by Robert Williams on 3/25/25.
//

import SwiftUI
import SwiftData
import MapKit

struct PersonView: View {
    let person: PersonModel

    @State private var isEditing = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Group {
                    Text("\(person.firstName ?? "") \(person.lastName ?? "")")
                        .font(.title.bold())

                    if let mobile = person.mobilePhone?.formattedAsPhone, !(person.mobilePhone ?? "").isEmpty {
                        Label(mobile, systemImage: "phone")
                    }

                    if let work = person.workPhone?.formattedAsPhone, !(person.workPhone ?? "").isEmpty {
                        Label(work, systemImage: "phone.fill")
                    }
                    
                    if let email = person.email, !email.isEmpty {
                        Label(email, systemImage: "envelope")
                    }

                    if let type = person.personType?.name {
                        Label("Type: \(type)", systemImage: "person.crop.circle")
                    }
                }

                Divider()

                if let home = person.homeAddress {
                    Text("Home Address")
                        .font(.headline)
                    addressButton(for: home)
                }

                if let work = person.workAddress {
                    Text("Work Address")
                        .font(.headline)
                    addressButton(for: work)
                }

                if person.homeAddress == nil && person.workAddress == nil {
                    Text("No addresses on file.")
                        .foregroundStyle(.secondary)
                }
            }
            .padding()
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Edit") {
                    isEditing = true
                }
            }
        }
        .sheet(isPresented: $isEditing) {
            EditPersonView(person: person)
        }
    }

    @ViewBuilder
    private func addressButton(for address: AddressModel) -> some View {
        Button {
            openInMaps(address)
        } label: {
            VStack(alignment: .leading, spacing: 4) {
                if let label = address.addressType?.name {
                    Text(label).font(.subheadline).bold()
                }
                if let line1 = address.address1 { Text(line1) }
                if let line2 = address.address2 { Text(line2) }
                HStack {
                    Text(address.city ?? "")
                    Text(address.state ?? "")
                    Text(address.zip ?? "")
                }
                .font(.caption)
                .foregroundStyle(.secondary)
            }
            .padding(.vertical, 4)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    private func openInMaps(_ address: AddressModel) {
        let fullAddress = [address.address1, address.address2, address.city, address.state, address.zip]
            .compactMap { $0 }
            .joined(separator: ", ")

        let encoded = fullAddress.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        if let url = URL(string: "http://maps.apple.com/?q=\(encoded)") {
            UIApplication.shared.open(url)
        }
    }
}

struct PersonView_Previews: PreviewProvider {
    static var previews: some View {
        let container = try! ModelContainer(
            for: PersonModel.self,
            AddressModel.self,
            AddressTypeModel.self,
            PersonTypeModel.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )

        let homeType = AddressTypeModel(name: "Home")
        let workType = AddressTypeModel(name: "Work")
        let personType = PersonTypeModel(name: "Renter")

        let person = PersonModel(
            firstName: "Jane",
            lastName: "Doe",
            mobilePhone: "1234567890",
            workPhone: "9876543210",
            email: "jane@example.com",
            ein: "12-3456789",
            ssn: "123-45-6789",
            personType: personType
        )

        let address1 = AddressModel(address1: "123 Main St", city: "Boston", state: "MA", zip: "02118")
        address1.addressType = homeType

        let address2 = AddressModel(address1: "456 Work Ave", address2: "Suite 500", city: "Cambridge", state: "MA", zip: "02139")
        address2.addressType = workType

        person.homeAddress = address1
        person.workAddress = address2

        container.mainContext.insert(homeType)
        container.mainContext.insert(workType)
        container.mainContext.insert(personType)
        container.mainContext.insert(person)
        container.mainContext.insert(address1)
        container.mainContext.insert(address2)

        return NavigationStack {
            PersonView(person: person)
        }
        .modelContainer(container)
    }
}
