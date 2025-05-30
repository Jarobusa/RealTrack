//
//  PersonViewModel.swift
//  RealTrack
//
//  Created by Robert Williams on 3/27/25.
//

import SwiftData
import SwiftUI

final class PersonViewModel: ObservableObject {
    @Published var people: [PersonModel] = []
    private var modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        // fetchPeople()
    }

    /// Fetch all people from SwiftData
    func fetchPeople() {
        let fetchDescriptor = FetchDescriptor<PersonModel>(sortBy: [SortDescriptor(\.lastName)])
        do {
            people = try modelContext.fetch(fetchDescriptor)
            print("✅ Fetched people: \(people.map { $0.firstName })")
        } catch {
            print("❌ Fetch error: \(error.localizedDescription)")
            people = []
        }
    }

    /// Add a new person
    func addPerson(
        firstName: String,
        lastName: String? = nil,
        mobilePhone: String? = nil,
        workPhone: String? = nil,
        email: String? = nil,
        ein: String? = nil,
        ssn: String? = nil,
        homeAddress: AddressModel? = nil,
        workAddress: AddressModel? = nil
    ) {
        let newPerson = PersonModel(
            firstName: firstName,
            lastName: lastName,
            mobilePhone: mobilePhone,
            workPhone: workPhone,
            email: email,
            ein: ein,
            ssn: ssn,
            homeAddress: homeAddress,
            workAddress: workAddress
        )
        
        modelContext.insert(newPerson)

        do {
            try modelContext.save()
            print("✅ Successfully inserted person: \(firstName)")
        } catch {
            print("❌ Failed to save person: \(error)")
        }

        fetchPeople()
    }

    /// Update an existing person
    func updatePerson(_ person: PersonModel) {
        do {
            try modelContext.save()
            print("✅ Successfully updated person: \(person.firstName ?? "Unknown")")
        } catch {
            print("❌ Failed to update person: \(error)")
        }
        fetchPeople()
    }

    /// Delete a person
    func deletePerson(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(people[index])
        }

        do {
            try modelContext.save()
            print("✅ Successfully deleted person")
        } catch {
            print("❌ Failed to delete person: \(error)")
        }

        fetchPeople()
    }

    /// Returns all people who have the specified address as either their home or work address
    func findPeopleByAddress(_ address: AddressModel) -> [PersonModel] {
           // When using UUIDs, we can use the ID directly for filtering
           let addressID = address.id
           
           let descriptor = FetchDescriptor<PersonModel>(
               predicate: #Predicate<PersonModel> { person in
                   (person.homeAddress?.id == addressID) || (person.workAddress?.id == addressID)
               }
           )
           
           do {
               let matchingPeople = try modelContext.fetch(descriptor)
               print("✅ Found \(matchingPeople.count) people linked to address ID: \(addressID)")
               return matchingPeople
           } catch {
               print("❌ Error finding people by address: \(error.localizedDescription)")
               return []
           }
       }
}
