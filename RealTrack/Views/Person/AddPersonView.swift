//
//  AddPersonView 2.swift
//  RealTrack
//
//  Created by Robert Williams on 4/12/25.
//

import SwiftUI

struct AddPersonView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) private var context

    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Name")) {
                    TextField("First Name", text: $firstName)
                    TextField("Last Name", text: $lastName)
                }

                Section(header: Text("Contact")) {
                    TextField("Email", text: $email)
                }
            }
            .navigationTitle("Add Person")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let person = PersonEntity(context: context)
                        person.firstName = firstName
                        person.lastName = lastName
                        person.email = email

                        try? context.save()
                        dismiss()
                    }
                    .disabled(firstName.isEmpty)
                }
            }
        }
    }
}
