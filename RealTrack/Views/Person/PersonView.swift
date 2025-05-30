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
    var house: HouseModel? = nil

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
                }

                Divider()

                if let home = person.homeAddress,
                   [home.address1, home.address2, home.city, home.state, home.zip].contains(where: { ($0 ?? "").isEmpty == false }) {
                    addressButton(for: home, title: "Home Address")
                }

                if let work = person.workAddress,
                   [work.address1, work.address2, work.city, work.state, work.zip].contains(where: { ($0 ?? "").isEmpty == false }) {
                    addressButton(for: work, title: "Work Address")
                }

                if person.homeAddress == nil && person.workAddress == nil {
                    Text("No addresses on file.")
                        .foregroundStyle(.secondary)
                }

                if let house = house, !house.associations.isEmpty {
                    Divider()
                    Text("House Residents")
                        .font(.title2)
                        .padding(.top)
                    ForEach(house.associations, id: \.id) { association in
                        let resident = association.person
                        // Exclude the current person from the list
                        if resident.id != person.id {
                            NavigationLink(destination: PersonView(person: resident, house: house)) {
                                Text("\(resident.firstName ?? "") \(resident.lastName ?? "")")
                                    .padding(.vertical, 4)
                            }
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
