//
//  GameCell.swift
//  JrAkademiProject
//
//  Created by cihad güzel on 31.05.2023.
//

import Alamofire

class GameListViewModel {

    var games: [Game] = []
    private var url: String?
    private let networkManager = NetworkManager()
    weak var delegate: GameListViewModelDelegate?

    // MARK: DefaultRequest
    func fetchGames() {
       // games = []
        url = "https://api.rawg.io/api/games?page_size=10&key=3be8af6ebf124ffe81d90f514e59856c"
        guard let baseUrl = url else { return }
        networkManager.fetchGames(from: baseUrl) { [weak self] (response: WelcomePageResponse?) in
            guard let games = response?.results else { return }
            self?.games.append(contentsOf: games)
            self?.delegate?.gamesFetched()
        }
    }

    // MARK: SearchRequest
    func fetchSearchResult(searchText: String) {
        games = []
        url = "https://api.rawg.io/api/games?page=1&page_size=10&search=\(searchText)&key=3be8af6ebf124ffe81d90f514e59856c"
        guard let baseUrl = url else { return }
        networkManager.fetchGames(from: baseUrl) { [weak self] (response: WelcomePageResponse?) in
            guard let games = response?.results else { return }
            self?.games = games
            self?.delegate?.gamesFetched()
        }
    }

    func numberOfGames() -> Int {
        return games.count
    }
}

protocol GameListViewModelDelegate: AnyObject {
    func gamesFetched()
}
