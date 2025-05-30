//
//  PersonView.swift
//  RealTrack
//
//  Created by Robert Williams on 3/23/25.
//

import SwiftUI
import SwiftData

struct PeopleView: View {
    @Environment(\.modelContext) private var context
    @Query private var people: [PersonModel]

    @State private var showingAddPerson = false
    @State private var selectedSortOption: SortOption = .firstName

    enum SortOption: String, CaseIterable, Identifiable {
        case firstName = "First Name"
        case lastName = "Last Name"
        var id: String { self.rawValue }
    }

    var body: some View {
        NavigationStack {
            VStack {
                Picker("Sort by", selection: $selectedSortOption) {
                    ForEach(SortOption.allCases) { option in
                        Text(option.rawValue).tag(option)
                    }
                }
                .pickerStyle(.segmented)
                .padding()

                List(sortedPeople, id: \.id) { person in
                    NavigationLink(destination: PersonView(person: person)) {
                        VStack(alignment: .leading) {
                            Text("\(person.firstName ?? "") \(person.lastName ?? "")")
                                .font(.headline)
                            if let phone = person.mobilePhone?.formattedAsPhone {
                                Text("📱 \(phone)")
                            }
                        }
                    }
                }
            }
            .navigationTitle("People")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingAddPerson = true
                    } label: {
                        Label("Add Person", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddPerson) {
                AddPersonView(viewModel: PersonViewModel(modelContext: context))
            }
        }
    }

    private var sortedPeople: [PersonModel] {
        switch selectedSortOption {
        case .firstName:
            return people.sorted { ($0.firstName ?? "") < ($1.firstName ?? "") }
        case .lastName:
            return people.sorted { ($0.lastName ?? "") < ($1.lastName ?? "") }
        }
    }
}
