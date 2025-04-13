//
//  HousesView.swift
//  RealTrack
//
//  Created by Robert Williams on 4/12/25.
//

import SwiftUI

// MARK: - HousesView
struct HousesView: View {
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \HouseEntity.name, ascending: true)],
        animation: .default
    ) private var houses: FetchedResults<HouseEntity>

    @State private var searchText = ""

    var filteredHouses: [HouseEntity] {
        if searchText.isEmpty {
            return Array(houses)
        } else {
            return houses.filter { house in
                house.address?.address1?.localizedCaseInsensitiveContains(searchText) == true ||
                house.address?.city?.localizedCaseInsensitiveContains(searchText) == true ||
                house.name?.localizedCaseInsensitiveContains(searchText) == true
            }
        }
    }

    var body: some View {
        NavigationStack {
            List(filteredHouses, id: \.objectID) { house in
                NavigationLink(destination: EditHouseView(house: house)) {
                    VStack(alignment: .leading) {
                        Text(house.name ?? "")
                            .font(.headline)
                        if let address = house.address {
                            Text("\(address.address1 ?? "") \(String(describing: address.city)), \(String(describing: address.state))")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("Houses")
            .searchable(text: $searchText)
        }
    }
}
