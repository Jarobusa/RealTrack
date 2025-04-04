//
//  AddHouseView.swift
//  RealTrack
//
//  Created by Robert Williams on 4/1/25.
//

import SwiftUI
import SwiftData

struct AddHouseView: View {
    @Environment(\.dismiss) private var dismiss

    let modelContext: ModelContext
    @StateObject private var houseViewModel: HouseViewModel

    @State private var houseName: String = ""
    @State private var address1: String = ""
    @State private var address2: String = ""
    @State private var city: String = ""
    @State private var state: String = ""
    @State private var zip: String = ""
    
    @State private var isPresentingSelectPersonView: Bool = false
    @State private var linkedPersons: [PersonModel] = []

    @FocusState private var isHouseNameFocused: Bool

    private var isSaveEnabled: Bool {
        !houseName.trimmingCharacters(in: .whitespaces).isEmpty &&
        !address1.trimmingCharacters(in: .whitespaces).isEmpty &&
        !city.trimmingCharacters(in: .whitespaces).isEmpty &&
        !state.trimmingCharacters(in: .whitespaces).isEmpty &&
        !zip.trimmingCharacters(in: .whitespaces).isEmpty
    }

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        _houseViewModel = StateObject(wrappedValue: HouseViewModel(context: modelContext))
    }

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("House Details")) {
                    TextField("House Name", text: $houseName, prompt: Text("Enter house name").foregroundColor(.gray))
                        .focused($isHouseNameFocused)
                }
                Section(header: Text("Address Details")) {
                    TextField("Address 1", text: $address1, prompt: Text("123 Main St").foregroundColor(.gray))
                    TextField("Address 2", text: $address2, prompt: Text("Apt 4B").foregroundColor(.gray))
                    TextField("City", text: $city, prompt: Text("City").foregroundColor(.gray))
                    TextField("State", text: $state, prompt: Text("State").foregroundColor(.gray))
                    TextField("Zip Code", text: $zip, prompt: Text("Zip Code").foregroundColor(.gray))
                        .keyboardType(.numberPad)
                }
                Section(header: Text("Linked Persons")) {
                    if linkedPersons.isEmpty {
                        Text("No linked persons")
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(linkedPersons, id: \.id) { person in
                            Text("\(person.firstName ?? "") \(person.lastName ?? "")")
                        }
                    }
                    Button {
                        isPresentingSelectPersonView = true
                    } label: {
                        HStack {
                            Image(systemName: "plus.circle")
                            Text("Add Linked Person")
                        }
                    }
                }
            }
            .navigationTitle("Add House")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.red)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        houseViewModel.saveHouse(
                            houseName: houseName,
                            address1: address1,
                            address2: address2,
                            city: city,
                            state: state,
                            zip: zip,
                            linkedPersons: linkedPersons
                        )
                        dismiss()
                    }
                    .disabled(!isSaveEnabled)
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    isHouseNameFocused = true
                }
            }
            .sheet(isPresented: $isPresentingSelectPersonView) {
                SelectPersonView { selectedPerson in
                    if !linkedPersons.contains(where: { $0.id == selectedPerson.id }) {
                        linkedPersons.append(selectedPerson)
                    }
                }
            }
        }
    }

}

struct AddHouseView_Previews: PreviewProvider {
    static var previews: some View {
        // Create a model container for the preview with the necessary model types
        let container = try! ModelContainer(for: HouseModel.self, AddressModel.self, PersonModel.self)
        let modelContext = container.mainContext
        return AddHouseView(modelContext: modelContext)
    }
}
