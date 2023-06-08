//
//  FavoritesViewModel.swift
//  JrAkademiProject
//
//  Created by cihad güzel on 1.06.2023.
//

import Foundation
import CoreData
import UIKit

class FavoritesViewModel {

    var gamesFavorites: [Game] = []
    var gameFav: Game?
    
    weak var delegate: FavoritesViewModelDelegate?

    // MARK: fetch Local Games
    func fetchLocalGames() -> Bool {


            gamesFavorites.removeAll()
          guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return false
          }
          let managedObjectContext: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
          let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoritesDB")
          fetchRequest.resultType = .dictionaryResultType
          fetchRequest.propertiesToFetch = ["id","metacritic", "name", "imageUrl", "genre"]
          fetchRequest.returnsDistinctResults = true

          do {
            let results = try managedObjectContext.fetch(fetchRequest) as! [NSDictionary]
            for result in results {


                let id = result["id"] as? Int ?? 0
                 let metacritic = result["metacritic"] as? Int
                 let name = result["name"] as? String
                 let image = result["imageUrl"] as? String

                guard let genresString = result["genre"] as? String else { return false }

                let genresArray = genresString.components(separatedBy: ", ")
                let genreObjects = genresArray.compactMap {
                    Genre(name: $0.trimmingCharacters(in: .whitespacesAndNewlines)) }

                let game = Game(id: id,
                                name: name,
                                backgroundImage: image,
                                metacritic: metacritic,
                                genres: genreObjects)

                gamesFavorites.append(game)
                print(game)

            }

              self.delegate?.gamesFetched()
          } catch let error as NSError {
            print("Could not fetch data: \(error), \(error.userInfo)")
          }
          return false
    }
}

protocol FavoritesViewModelDelegate: AnyObject {
    func gamesFetched()
}


