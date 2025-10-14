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
                    HouseDetailsContent(foundHouse: foundHouse, viewModel: viewModel)
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

// MARK: - HouseDetailsContent
// Extract the main content of the HouseView into a separate subview.
private struct HouseDetailsContent: View {
    let foundHouse: HouseModel
    @ObservedObject var viewModel: HouseViewModel // Use @ObservedObject for subview

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HouseNameView(name: foundHouse.name)
            if let address = foundHouse.address {
                AddressDetailsView(address: address)
            } else {
                Text("No Address")
                    .font(.subheadline)
            }

            Divider()
            LastUpdatedView(timestamp: foundHouse.timestamp)

            Spacer()
        }
    }
}

// MARK: - HouseNameView
// Subview for displaying the house name.
private struct HouseNameView: View {
    let name: String?

    var body: some View {
        if let name = name, !name.isEmpty {
            Text(name)
                .font(.title2)
                .bold()
        } else {
            Text("Unnamed House")
                .font(.title2)
                .bold()
        }
    }
}

// MARK: - AddressDetailsView
// Subview for displaying address details and the map link.
private struct AddressDetailsView: View {
    let address: AddressModel // Assuming AddressModel is defined and accessible

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            if let address1 = address.address1,
               let city = address.city,
               let state = address.state {
                let fullAddress = "\(address1), \(city), \(state)"
                if let encoded = fullAddress.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                   let url = URL(string: "http://maps.apple.com/?q=\(encoded)") {
                    HStack(spacing: 4) {
                        Image(systemName: "house")
                            .foregroundColor(.blue)
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

            if let address2 = address.address2, !address2.isEmpty {
                Text(address2)
                    .font(.subheadline)
            }
        }
    }
}

// MARK: - LastUpdatedView
// Subview for displaying the last updated timestamp.
private struct LastUpdatedView: View {
    let timestamp: Date

    var body: some View {
        HStack {
            Image(systemName: "calendar")
            Text("Last updated on \(timestamp.formatted(date: .abbreviated, time: .shortened))")
        }
        .font(.footnote)
        .foregroundColor(.secondary)
    }
}
