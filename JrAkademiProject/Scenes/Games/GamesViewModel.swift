//
//  GameCell.swift
//  JrAkademiProject
//
//  Created by cihad güzel on 31.05.2023.
//

import Alamofire
import CoreData

class GameListViewModel {

    var gamesDefault: [Game] = []
    var gamesSearch: [Game] = []
    var isSearchRequest: Bool = false
    private var url: String?
    var page: Int = 0
    var pageSearch: Int = 0
    var idArray: [String] = []
    private let networkManager = NetworkManager()
    weak var delegate: GameListViewModelDelegate?

    // MARK: DefaultRequest
    func fetchGames() {
       // games = []

        isSearchRequest = false
        page+=1
        url = "https://api.rawg.io/api/games?page=\(page)&page_size=10&key=d034a75038454466bec9e04d774a3336"
        guard let baseUrl = url else { return }
        networkManager.fetchGames(from: baseUrl) { [weak self] (response: WelcomePageResponse?) in
            guard let games = response?.results else { return }
            self?.gamesDefault.append(contentsOf: games)
            self?.delegate?.gamesFetched()
        }
    }

    // MARK: SearchRequest
    func fetchSearchResult(searchText: String) {

        isSearchRequest = true
        pageSearch+=1
        url = "https://api.rawg.io/api/games?page=\(pageSearch)&page_size=10&search=\(searchText)&key=d034a75038454466bec9e04d774a3336"
        guard let baseUrl = url else { return }
        networkManager.fetchGames(from: baseUrl) { [weak self] (response: WelcomePageResponse?) in
            guard let games = response?.results else { return }
            self?.gamesSearch.append(contentsOf: games)
            self?.delegate?.gamesFetched()
        }
    }

    func fetchAllIDs() {
        var idArray: [String] = []
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ClickedGamesDB")
        fetchRequest.propertiesToFetch = ["id"]
        fetchRequest.resultType = .dictionaryResultType
        do {  print("******")
            let results = try context.fetch(fetchRequest) as? [[String: Any]]
            for result in results ?? [] {
                if let id = result["id"] as? String {
                    idArray.append(id)
                    print(id)

                }
            }
        } catch let error as NSError {
            print("Could not fetch IDs. \(error), \(error.userInfo)")
        }
        self.idArray = idArray
    }

    func checkId(_ id: Int) -> Bool {
        return idArray.contains(String(id))
    }

    func saveClicked(id: Int){
        /// CoreData'deki veritabanı işlemlerini gerçekleştir
          guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
          let context = appDelegate.persistentContainer.viewContext

        let clicked = NSEntityDescription.insertNewObject(forEntityName: "ClickedGamesDB", into: context)

        /// Daha önce kaydedilmiş mi kontrol et
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ClickedGamesDB")
        fetchRequest.predicate = NSPredicate(format: "id == %@", String(id))
        do {
          let results = try context.fetch(fetchRequest)
            if !results.isEmpty{
                return
            }
        } catch { print("Favori Bulunamadı") }


        print(id)
          clicked.setValue(String(id), forKeyPath: "id")

          do {
            try context.save()
          } catch let error as NSError {
              print("ID kaydedilemedi: \(error), \(error.userInfo)")
          }
      }
}

protocol GameListViewModelDelegate: AnyObject {
    func gamesFetched()
}
