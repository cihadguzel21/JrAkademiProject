//
//  Game.swift
//  JrAkademiProject
//
//  Created by cihad güzel on 31.05.2023.
//
import Foundation

// MARK: - Welcome
struct DetailResponseModel: Decodable {

    let id: Int
    let name: String?
    let descriptionRaw: String?
    let backgroundImageAdditional: String?
    let website: String?
    let redditURL: String?
    let metacritic: Int?
    let genres: [Genre]?


    enum CodingKeys: String, CodingKey {
        case id
        case name
        case descriptionRaw = "description_raw"
        case backgroundImageAdditional = "background_image_additional"
        case website
        case redditURL = "reddit_url"
        case metacritic
        case genres
    }
}
