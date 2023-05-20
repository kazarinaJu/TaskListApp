//
//  StorageManager.swift
//  TaskListApp
//
//  Created by Юлия Ястребова on 20.05.2023.
//

import Foundation
import CoreData

final class StorageManager {
    static let shared = StorageManager()
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TaskListApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private init() {}
    
    // MARK: - Core Data Saving support
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func saveTask() -> Task? {
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "Task", in: persistentContainer.viewContext) else {
            return nil
        }
        let task = Task(entity: entityDescription, insertInto: persistentContainer.viewContext)
        return task
    }
    
    func fetchData() -> [Task] {
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        
        do {
            let data = try persistentContainer.viewContext.fetch(fetchRequest)
            return data
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    func updateTask() {
        saveContext()
    }
    
    func deleteTask(_ managedObject: Task) {
        persistentContainer.viewContext.delete(managedObject)
        saveContext()
    }
}
