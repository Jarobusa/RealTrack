//
//  PeopleView
//  RealTrack
//
//  Created by Robert Williams on 4/12/25.
//

import CoreData
import SwiftUI

struct PeopleView: View {
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \PersonEntity.firstName, ascending: true)],
        animation: .default
    ) private var people: FetchedResults<PersonEntity>
    
    @State private var searchText = ""

    var filteredPeople: [PersonEntity] {
        if searchText.isEmpty {
            return Array(people)
        } else {
            return people.filter {
                ($0.firstName?.localizedCaseInsensitiveContains(searchText) == true) ||
                ($0.lastName?.localizedCaseInsensitiveContains(searchText) == true)
            }
        }
    }

    var body: some View {
        NavigationStack {
            List(filteredPeople, id: \.objectID) { person in
                NavigationLink(destination: EditPersonView(person: person)) {
                    VStack(alignment: .leading) {
                        Text("\(person.firstName ?? "") \(person.lastName ?? "")")
                            .font(.headline)
                        if let email = person.email {
                            Text(email)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("People")
            .searchable(text: $searchText)
        }
    }
}

