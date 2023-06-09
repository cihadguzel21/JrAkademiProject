//
//  GameCell.swift
//  JrAkademiProject
//
//  Created by cihad güzel on 31.05.2023.
//

import Alamofire

class GameListViewModel {

    var gamesDefault: [Game] = []
    var gamesSearch: [Game] = []
    var isSearchRequest: Bool = false
    private var url: String?
    var page: Int = 0
    var pageSearch: Int = 0
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
}

protocol GameListViewModelDelegate: AnyObject {
    func gamesFetched()
}
