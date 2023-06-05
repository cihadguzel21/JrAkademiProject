//
//  DetailsViewmodel.swift
//  JrAkademiProject
//
//  Created by cihad güzel on 4.06.2023.
//

import Alamofire

class DetailsViewModel {

    var gameDetails: DetailResponseModel?
    private var url: String?
    private let networkManager = NetworkManager()
    weak var delegate: DetailsViewModelDelegate?

    // MARK: DefaultRequest
    func fetchDetails(gameID: String) {

        url = "https://api.rawg.io/api/games/\(gameID)?key=3be8af6ebf124ffe81d90f514e59856c"
        guard let baseUrl = url else { return }
        networkManager.fetchGames(from: baseUrl) { [weak self] (response: DetailResponseModel?) in
            guard let gameDetails = response else { return }
            self?.gameDetails = gameDetails
            self?.delegate?.detailsFetched()
        }
    }
}

protocol DetailsViewModelDelegate: AnyObject {
    func detailsFetched()
}
