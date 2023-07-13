//
//  Core.swift
//  TinyHabits
//
//  Created by Hubert Le on 7/26/22.
//

import Foundation
import CoreData

class CoreDataViewModel: ObservableObject {
    let container: NSPersistentContainer
    @Published var savedEntities: [HabitEntity] = []
    
    init() {
        container = NSPersistentContainer(name: "Habit")
        container.loadPersistentStores { (description, error) in
            if let error = error {
                print("ERROR LOADING CORE DATA. \(error)")
            }
        }
        fetchHabit()
    }
    func fetchHabit() {
        let request = NSFetchRequest<HabitEntity>(entityName: "HabitEntity")
        do {
            try container.viewContext.fetch(request)
        } catch let error {
            print("Error fetching. \(error)")
        }
    }
    
    func addHabit(text: String) {
        let newHabit = HabitEntity(context: container.viewContext)
        newHabit.task = text
        saveData()
    }
    
    func saveData() {
        do {
            try container.viewContext.save()
            fetchHabit()
        } catch let error {
            print("Error saving. \(error)")
        }
    }
}
