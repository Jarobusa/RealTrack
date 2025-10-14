//
//  PersonView.swift
//  RealTrack
//
//  Created by Robert Williams on 3/25/25.
//

import SwiftUI
import SwiftData
import MapKit
import Foundation

struct PersonView: View {
    let person: PersonModel
    var house: HouseModel? = nil

    @State private var isEditing = false

    private func makeDisplayName(from person: PersonModel) -> String {
        [person.firstName, person.lastName]
            .compactMap { $0?.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
            .joined(separator: " ")
    }

    private func hasAnyAddressData(_ address: AddressModel) -> Bool {
        let parts = [address.address1, address.address2, address.city, address.state, address.zip]
        return parts.contains { ($0 ?? "").isEmpty == false }
    }

    var body: some View {
        let displayName = makeDisplayName(from: person)
        
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Group {
                    Text(displayName)
                        .font(.title.bold())

                    let mobile = person.mobilePhone?.formattedAsPhone
                    if let mobile, !mobile.isEmpty {
                        Label(mobile, systemImage: "phone")
                    }

                    let work = person.workPhone?.formattedAsPhone
                    if let work, !work.isEmpty {
                        Label(work, systemImage: "phone.fill")
                    }
                    
                    let email = person.email
                    if let email, !email.isEmpty {
                        Label(email, systemImage: "envelope")
                    }
                }

                Divider()

                if let home = person.homeAddress, hasAnyAddressData(home) {
                    addressButton(for: home, title: "Home Address")
                }

                if let work = person.workAddress, hasAnyAddressData(work) {
                    addressButton(for: work, title: "Work Address")
                }

                if person.homeAddress == nil && person.workAddress == nil {
                    Text("No addresses on file.")
                        .foregroundStyle(.secondary)
                }

                if let house = house, let associations = house.associations, !associations.isEmpty {
                    Divider()
                    Text("House Residents")
                        .font(.title2)
                        .padding(.top)
                    // Build a list of (association, resident) pairs excluding the current person
                    let otherResidents = associations.compactMap { assoc -> (HouseAssociationModel, PersonModel)? in
                        guard let resident = assoc.person else { return nil }
                        return resident.id == person.id ? nil : (assoc, resident)
                    }

                    // Use the association's id as a stable identifier
                    ForEach(otherResidents, id: \.0.id) { pair in
                        let resident = pair.1
                        NavigationLink(destination: PersonView(person: resident, house: house)) {
                            Text("\(resident.firstName ?? "") \(resident.lastName ?? "")")
                                .padding(.vertical, 4)
                        }
                    }
                }
                
                Divider()
                
                // Last Updated
                HStack {
                    Image(systemName: "calendar")
                    Text("Last updated on \(person.timestamp.formatted(date: .abbreviated, time: .shortened))")
                }
                .font(.footnote)
                .foregroundColor(.secondary)
                
                Spacer()
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
    private func addressButton(for address: AddressModel, title: String) -> some View {
        Button {
            openInMaps(address)
        } label: {
            VStack(alignment: .leading, spacing: 2) {
                // Emphasize the title text for the address (Home Address/Work Address)
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)
                // The remaining address lines use a smaller, lighter style.
                if let line1 = address.address1 { Text(line1) }
                if let line2 = address.address2 { Text(line2) }
                HStack {
                    Text(address.city ?? "")
                    Text(address.state ?? "")
                    Text(address.zip ?? "")
                }
            }
            .padding(.vertical, 2)
            .contentShape(Rectangle())
            .font(.caption)
            .foregroundStyle(.secondary)
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
