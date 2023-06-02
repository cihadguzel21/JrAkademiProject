//
//  GameCell.swift
//  JrAkademiProject
//
//  Created by cihad güzel on 31.05.2023.
//

import Alamofire

class GameListViewModel {

    var games: [Game] = []
    private let baseUrl = "https://api.rawg.io/api/games?key=3be8af6ebf124ffe81d90f514e59856c"
    private let networkManager = NetworkManager()
    weak var delegate: GameListViewModelDelegate?

    func fetchGames() {
        networkManager.fetchGames(from: baseUrl) { [weak self] (response: WelcomePageResponse?) in
            guard let games = response?.results else { return }
            self?.games = games
            self?.delegate?.gamesFetched()
        }
    }


  /*  func getGames(completion: @escaping () -> Void) {
        AF.request(url).responseJSON { [weak self] response in
            guard let self = self else { return }

            switch response.result {
            case .success(let value):
                if let data = value as? [String: Any],
                   let results = data["results"] as? [[String: Any]] {

                    var gameList: [Game] = []

                    for result in results {
                        if let name = result["name"] as? String,
                           let backgroundImage = result["background_image"] as? String,
                           let metacritic = result["metacritic"] as? Int {

                            let game = Game(name: name, background_image: backgroundImage, metacritic: metacritic)
                            gameList.append(game)
                        }
                    }

                    self.games = gameList
                    completion()
                }
            case .failure(let error):
                print("Request failed with error: \(error)")
            }
        }
    }*/

    func numberOfGames() -> Int {
        return games.count
    }
}

protocol GameListViewModelDelegate: class {
    func gamesFetched()
}
