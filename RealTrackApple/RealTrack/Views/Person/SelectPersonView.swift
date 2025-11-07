//
//  SelectPersonView.swift
//  RealTrack
//
//  Created by Robert Williams on 4/1/25.

import SwiftUI
import SwiftData

struct SelectPersonView: View {
    @Environment(\.dismiss) private var dismiss
    @Query(sort: \PersonModel.firstName) var persons: [PersonModel]
    
    var onSelect: (PersonModel) -> Void
    
    var body: some View {
        NavigationStack {
            List(persons, id: \.id) { person in
                Button {
                    onSelect(person)
                    dismiss()
                } label: {
                    HStack {
                        Text(person.firstName ?? "")
                        Text(person.lastName ?? "")
                    }
                }
            }
            .navigationTitle("Select Person")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.red)
                }
            }
        }
    }
}
