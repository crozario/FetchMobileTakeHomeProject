//
//  RecipeModel.swift
//  FetchMobileTakeHomeProject
//
//  Created by Crossley Rozario on 11/12/24.
//

import Foundation

struct RecipeModel: Codable, Equatable {
    let cuisine: String
    let name: String
    let photoUrlLarge: String?
    let photoUrlSmall: String?
    let uuid: String
    let sourceURL: String?
    let youtubeURL: String?
    
    enum CodingKeys: String, CodingKey {
        case cuisine = "cuisine"
        case name = "name"
        case photoUrlLarge = "photo_url_large"
        case photoUrlSmall = "photo_url_small"
        case uuid = "uuid"
        case sourceURL = "source_url"
        case youtubeURL = "youtube_url"
    }
}

struct RecipesModel: Codable {
    let recipes: [RecipeModel]
}
