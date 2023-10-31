//
//  DataManager.swift
//  Swooz
//
//  Created by mora hakim on 22/10/23.
//

import Foundation
import CoreData

class DataManager {
  static let shared = DataManager()
  lazy var persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "Database")
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    })
    return container
  }()
  //Core Data Saving support
    
    func game(createdAt: Date, duration: Int) -> Game {
        let game = Game(context: persistentContainer.viewContext)
        game.createdAt = createdAt
        game.duration = Int16(duration)
        return game
    }
    
    func games(shoot: Shoot) -> [Game] {
        let request: NSFetchRequest<Game> = Game.fetchRequest()
        request.predicate = NSPredicate(format: "shoot = %@", shoot)
        request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        var fetchGame: [Game] = []
        
        do {
            fetchGame = try persistentContainer.viewContext.fetch(request)
        }catch let error{
            print("Error fetching game \(error)")
        }
        return fetchGame
    }
    
    func shoot(area: String, technique: String, time: String, hit: Bool, game: Game) -> Shoot {
        let shoot = Shoot(context: persistentContainer.viewContext)
        shoot.area = area
        shoot.hit = hit
        shoot.technique = technique
        shoot.time = time
        game.addToShoots(shoot)
        return shoot
    }
    
    func shoots() -> [Shoot] {
        let request: NSFetchRequest<Shoot> = Shoot.fetchRequest()
        var fetchShoot: [Shoot] = []
        
        do {
            fetchShoot = try persistentContainer.viewContext.fetch(request)
        }catch let error {
            print("Error fetching shoot \(error)")
        }
        return fetchShoot
    }
    
  func save () {
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
}
