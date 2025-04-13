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
        seedDefaultRolesIfNeeded()
    }

    var context: NSManagedObjectContext {
        container.viewContext
    }

    static let preview = CoreDataManager(inMemory: true)

    private func seedDefaultRolesIfNeeded() {
        let request: NSFetchRequest<RoleEntity> = RoleEntity.fetchRequest()
        request.fetchLimit = 1

        do {
            let count = try context.count(for: request)
            if count == 0 {
                let roles = ["Owner", "Renter", "Handy Man"]
                for name in roles {
                    let role = RoleEntity(context: context)
                    role.name = name
                }
                try context.save()
                print("✅ Seeded default roles.")
            }
        } catch {
            print("❌ Failed to seed roles: \(error)")
        }
    }
}
