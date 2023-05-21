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
    
    // MARK: - CRUD Methods
    func save() -> Task {
        let task = Task(context: persistentContainer.viewContext)
        return task
    }
    
    func fetchData() -> [Task] {
        let fetchRequest = Task.fetchRequest()
        
        do {
            let data = try persistentContainer.viewContext.fetch(fetchRequest)
            return data
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    func update(task: Task) {
        saveContext()
    }
    
    func delete(task: Task) {
        persistentContainer.viewContext.delete(task)
        saveContext()
    }
}

