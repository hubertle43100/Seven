//
//  CoreDataViewModel.swift
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
            savedEntities = try container.viewContext.fetch(request)
        } catch let error {
            print("Error fetching. \(error)")
        }
    }
    
    func addHabit(text: String, nums: Float) {
        let newHabit = HabitEntity(context: container.viewContext)
        newHabit.task = text
        //newHabit.progressValue = nums
        saveData()
    }
    
    func completeTask(entity: HabitEntity) {
        entity.isComplete = !entity.isComplete
        saveData()
    }
    
    func resetTask() {
        savedEntities[0].isComplete = false
        savedEntities[1].isComplete = false
        savedEntities[2].isComplete = false
        saveData()
    }
    
    func daysCounted() {
        if savedEntities[0].isComplete == true {
            savedEntities[0].daysCount += 1
            print("\(savedEntities[0].daysCount)")
        } else {
            savedEntities[0].daysCount = 0
        }
        if savedEntities[1].isComplete == true {
            savedEntities[1].daysCount += 1
            print("\(savedEntities[1].daysCount)")
        } else {
            savedEntities[1].daysCount = 0
        }
        if savedEntities[2].isComplete == true {
            savedEntities[2].daysCount += 1
            print("\(savedEntities[2].daysCount)")
        } else {
            savedEntities[2].daysCount = 0
        }
    }
    
    func updateHabit(entity: HabitEntity) {
        let currentTask = entity.task ?? ""
        let newTask = currentTask + "!"
        entity.task = newTask
        saveData()
    }
    
    func deleteHabit(indexSet: IndexSet) {
        guard let index = indexSet.first else {return}
        let entity = savedEntities[index]
        container.viewContext.delete(entity)
        saveData()
    }
    
    func quickDeleteHabit() {
        let entity = savedEntities[0]
        container.viewContext.delete(entity)
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


