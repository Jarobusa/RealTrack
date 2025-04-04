//
//  HouseViewModel.swift
//  RealTrack
//
//  Created by Robert Williams on 3/30/25.
//

import SwiftData
import SwiftUI

/// ViewModel that manages a collection of HouseModel instances and provides methods to manipulate them.
final class HouseViewModel: ObservableObject {
    /// The list of all houses managed by this view model.
    @Published var houses: [HouseModel] = []
    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
        loadHouses()
    }

    private func loadHouses() {
        let fetchDescriptor = FetchDescriptor<HouseModel>()
        do {
            houses = try context.fetch(fetchDescriptor)
        } catch {
            print("Error fetching houses: \(error)")
        }
    }

    /// Adds a new house to the list.
    /// - Parameters:
    ///   - name: The name of the house.
    ///   - address: The address associated with the house.
    func addHouse(name: String, address: AddressModel) {
        let newHouse = HouseModel(name: name, address: address)
        houses.append(newHouse)
    }

    /// Deletes the specified house from the list.
    /// - Parameter house: The house to be removed.
    func deleteHouse(_ house: HouseModel) {
        houses.removeAll { $0.id == house.id }
    }

    /// Returns the people associated with the specified house.
    /// - Parameter house: The house whose people should be listed.
    /// - Returns: An array of people in the given house.
    func people(in house: HouseModel) -> [PersonModel] {
        return house.personModel
    }

    /// Returns all houses.
    /// - Returns: An array of all HouseModel instances.
    func getAllHouses() -> [HouseModel] {
        loadHouses()
        return houses
    }

    /// Saves a new house with the given details and linked persons.
    /// - Parameters:
    ///   - houseName: The name of the house.
    ///   - address1: The primary address line.
    ///   - address2: The secondary address line (optional).
    ///   - city: The city.
    ///   - state: The state.
    ///   - zip: The zip code.
    ///   - linkedPersons: An array of PersonModel instances to link with the house.
    func saveHouse(houseName: String, address1: String, address2: String, city: String, state: String, zip: String, linkedPersons: [PersonModel]) {
        let newAddress = AddressModel(
            id: UUID(),
            address1: address1,
            address2: address2.isEmpty ? nil : address2,
            city: city,
            state: state,
            zip: zip,
            timestamp: Date()
        )
        context.insert(newAddress)

        let newHouse = HouseModel(
            id: UUID(),
            name: houseName,
            address: newAddress,
            timestamp: Date()
        )
        newHouse.personModel.append(contentsOf: linkedPersons)
        context.insert(newHouse)

        do {
            try context.save()
            houses.append(newHouse)
        } catch {
            print("❌ Error saving house: \(error)")
        }
    }
}
