//
//  HouseView.swift
//  RealTrack
//
//  Created by Robert Williams on 4/4/25.
//

import SwiftUI
import SwiftData

// MARK: - HouseView
struct HouseView: View {
    @Environment(\.modelContext) private var context
    @StateObject private var viewModel: HouseViewModel
    private let selectedHouse: HouseModel

    // New initializer to create the view model and assign the selected house.
    init(modelContext: ModelContext, house: HouseModel) {
        _viewModel = StateObject(wrappedValue: HouseViewModel(context: modelContext))
        self.selectedHouse = house
    }

    var body: some View {
        NavigationStack {
            if let foundHouse = viewModel.findHouse(by: selectedHouse.id) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 12) {
                        // House Name displayed as plain text.
                        if let name = foundHouse.name, !name.isEmpty {
                            Text(name)
                                .font(.title2)
                                .bold()
                        } else {
                            Text("Unnamed House")
                                .font(.title2)
                                .bold()
                        }

                        // Address Details
                        VStack(alignment: .leading, spacing: 4) {
                            if let address1 = foundHouse.address.address1,
                               let city = foundHouse.address.city,
                               let state = foundHouse.address.state {
                                let fullAddress = "\(address1), \(city), \(state)"
                                if let encoded = fullAddress.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                                   let url = URL(string: "http://maps.apple.com/?q=\(encoded)") {
                                    HStack(spacing: 4) {
                                        // House image displayed separately
                                        Image(systemName: "house")
                                            .foregroundColor(.blue)
                                        // Only the text is wrapped in a Link
                                        Link(destination: url) {
                                            Text(fullAddress)
                                                .font(.subheadline)
                                                .foregroundColor(.blue)
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                    }
                                    .padding(.top, 4)
                                }
                            } else {
                                Text("No Address")
                                    .font(.subheadline)
                            }
                            
                            // Optionally display address line 2
                            if let address2 = foundHouse.address.address2, !address2.isEmpty {
                                Text(address2)
                                    .font(.subheadline)
                            }
                        }

                        // Residents Section: Group people by personType
                        if !viewModel.people(in: foundHouse).isEmpty {
                            Divider()
                            
                            Text("People")
                                .font(.title3)
                                .padding(.top)
                            Group {
                                // Group people by their personType name (or "Unknown" if missing)
                                let groupedPeople = Dictionary(grouping: viewModel.people(in: foundHouse)) { person in
                                    person.personType?.name ?? "Unknown"
                                }
                                ForEach(groupedPeople.keys.sorted(), id: \.self) { typeKey in
                                    VStack(alignment: .leading) {
                                        Text(typeKey)
                                            .font(.headline)
                                            .padding(.vertical, 4)
                                        ForEach(groupedPeople[typeKey] ?? [], id: \.id) { person in
                                            NavigationLink(destination: PersonView(person: person)) {
                                                VStack(alignment: .leading, spacing: 2) {
                                                    Text("\(person.firstName ?? "") \(person.lastName ?? "")")
                                                        .padding(.vertical, 2)
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        
                        // Divider separating house info from the last updated timestamp.
                        Divider()
                        
                        // Last Updated
                        HStack {
                            Image(systemName: "calendar")
                            Text("Last updated on \(foundHouse.timestamp.formatted(date: .abbreviated, time: .shortened))")
                        }
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        
                        Spacer()
                    }
                    .padding()
                }
                .navigationTitle("House Details")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink(destination: EditHouseView(house: foundHouse)) {
                            Text("Edit")
                        }
                    }
                }
            } else {
                Text("No house available")
                    .foregroundColor(.secondary)
                    .italic()
            }
        }
    }
}
