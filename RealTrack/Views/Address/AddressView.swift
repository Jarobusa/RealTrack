import SwiftUI
import SwiftData

struct AddressView: View {
    let address: AddressModel
    @State private var isEditing = false

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Address Details")) {
                    HStack {
                        Text("Address 1")
                        Spacer()
                        Text(address.address1 ?? "—")
                            .foregroundColor(.gray)
                    }
                    HStack {
                        Text("Address 2")
                        Spacer()
                        Text(address.address2 ?? "—")
                            .foregroundColor(.gray)
                    }
                    HStack {
                        Text("City")
                        Spacer()
                        Text(address.city ?? "—")
                            .foregroundColor(.gray)
                    }
                    HStack {
                        Text("State")
                        Spacer()
                        Text(address.state ?? "—")
                            .foregroundColor(.gray)
                    }
                    HStack {
                        Text("Zip")
                        Spacer()
                        Text(address.zip ?? "—")
                            .foregroundColor(.gray)
                    }
                }
            }
            .navigationTitle("Address")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Edit") {
                        isEditing = true
                    }
                }
            }
            .sheet(isPresented: $isEditing) {
                EditAddressView(address: address)
            }
        }
    }
}