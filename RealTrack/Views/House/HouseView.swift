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
                        // House Name
                        Text(foundHouse.name?.isEmpty == false ? foundHouse.name! : "Unnamed House")
                            .font(.title2)
                            .bold()

                        // Address
                        VStack(alignment: .leading, spacing: 4) {
                            Label {
                                Text(foundHouse.address.address1 ?? "No Address")
                            } icon: {
                                Image(systemName: "house")
                            }

                            if let address2 = foundHouse.address.address2, !address2.isEmpty {
                                Text(address2)
                                    .font(.subheadline)
                            }

                            Text([
                                foundHouse.address.city,
                                foundHouse.address.state,
                                foundHouse.address.zip
                            ]
                            .compactMap { $0 }
                            .joined(separator: ", "))
                            .font(.subheadline)

                            if let address1 = foundHouse.address.address1,
                               let city = foundHouse.address.city,
                               let state = foundHouse.address.state {
                                let fullAddress = "\(address1), \(city), \(state)"
                                if let encoded = fullAddress.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                                   let url = URL(string: "http://maps.apple.com/?q=\(encoded)") {
                                    Link(destination: url) {
                                        Label("Open in Apple Maps", systemImage: "map.fill")
                                            .font(.subheadline)
                                            .foregroundColor(.blue)
                                            .padding(.top, 4)
                                    }
                                }
                            }
                        }

                        // Timestamp
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
            } else {
                Text("No house available")
                    .foregroundColor(.secondary)
                    .italic()
            }
        }
    }
}
