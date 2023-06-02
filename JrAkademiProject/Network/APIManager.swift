//
//  APIManager.swift
//  JrAkademiProject
//
//  Created by cihad güzel on 1.06.2023.
//
import Alamofire

class NetworkManager {
    func fetchGames<T: Decodable>(from url: String, completion: @escaping (T?) -> Void) {
        AF.request(url).responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let result):
                completion(result)
            case .failure(let error):
                print("Error: \(error)")
                completion(nil)
            }
        }
    }
}
