import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()

    let container: NSPersistentContainer

    private init(inMemory: Bool = false) {
        let container = NSPersistentCloudKitContainer(name: "RealTrackModel")
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Unresolved Core Data error: \(error)")
            }
        }

        self.container = container
        deleteAllData()
        seedDefaultRolesIfNeeded()
    }

    var context: NSManagedObjectContext {
        container.viewContext
    }

    static let preview = CoreDataManager(inMemory: true)

    private func seedDefaultRolesIfNeeded() {
        let request: NSFetchRequest<RoleEntity> = RoleEntity.fetchRequest()

        do {
            let existingRoles = try context.fetch(request).map { $0.name ?? "" }

            let rolesToInsert = ["Owner", "Renter", "Handy Man"].filter { role in
                !existingRoles.contains(role)
            }

            for name in rolesToInsert {
                let role = RoleEntity(context: context)
                role.id = UUID()
                role.name = name
                print("🌱 Seeding role: \(name), id: \(role.id?.uuidString ?? "nil")")
            }

            if !rolesToInsert.isEmpty {
                try context.save()
                print("✅ Seeded default roles.")
            }

        } catch {
            print("❌ Failed to seed roles: \(error)")
        }
    }
    
    func deleteAllData() {
        let entities = container.managedObjectModel.entities

        for entity in entities {
            guard let name = entity.name else { continue }
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: name)
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

            do {
                try context.execute(batchDeleteRequest)
                print("🗑️ Deleted all data for entity: \(name)")
            } catch {
                print("❌ Failed to delete data for \(name): \(error)")
            }
        }

        do {
            try context.save()
            print("✅ All data deleted.")
        } catch {
            print("❌ Failed to save context after deletion: \(error)")
        }
    }
}
