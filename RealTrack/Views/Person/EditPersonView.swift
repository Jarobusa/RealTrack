//
//  EditPersonView.swift
//  RealTrack
//
//  Created by Robert Williams on 4/12/25.
//

import SwiftUI

struct EditPersonView: View {
    @ObservedObject var person: PersonEntity

    var body: some View {
        Form {
            Section(header: Text("Name")) {
                TextField("First Name", text: Binding(
                    get: { person.firstName ?? "" },
                    set: { person.firstName = $0 }
                ))
                TextField("Last Name", text: Binding(
                    get: { person.lastName ?? "" },
                    set: { person.lastName = $0 }
                ))
            }

            Section(header: Text("Contact")) {
                TextField("Email", text: Binding(
                    get: { person.email ?? "" },
                    set: { person.email = $0 }
                ))
                TextField("Mobile Phone", text: Binding(
                    get: { person.mobilePhone ?? "" },
                    set: { person.mobilePhone = $0 }
                ))
                TextField("Work Phone", text: Binding(
                    get: { person.workPhone ?? "" },
                    set: { person.workPhone = $0 }
                ))
            }
        }
        .navigationTitle("Edit Person")
    }
}

