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

    /// Returns the people associated with the specified house.
    /// - Parameter house: The house whose people should be listed.
    /// - Returns: An array of PersonModel instances associated with the house.
    func people(in house: HouseModel) -> [PersonModel] {
        return house.associations.compactMap { $0.person }
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
    ///   - linkedPersons: An array of PersonModel instances to associate with the house.
    func saveHouse(houseName: String, address1: String, address2: String, city: String, state: String, zip: String, linkedPersons: [PersonModel]) {
        // Create and insert a new address.
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

        // Create the new house.
        let newHouse = HouseModel(
            id: UUID(),
            name: houseName,
            address: newAddress,
            timestamp: Date()
        )

        // For each linked person, create a HouseAssociation to record the relationship.
        for person in linkedPersons {
            let association = HouseAssociationModel(house: newHouse, person: person)
            newHouse.associations.append(association)
            person.houseAssociations.append(association)
            context.insert(association)
        }

        // Insert the new house and save.
        context.insert(newHouse)
        do {
            try context.save()
            houses.append(newHouse)
        } catch {
            print("❌ Error saving house: \(error)")
        }
    }

    /// Finds and returns the HouseModel with the specified id.
    /// - Parameter id: The UUID of the house to find.
    /// - Returns: The HouseModel if found, or nil if not found.
    func findHouse(by id: UUID) -> HouseModel? {
        return houses.first { $0.id == id }
    }
}
