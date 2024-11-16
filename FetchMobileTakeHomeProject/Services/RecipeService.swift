//
//  RecipeService.swift
//  FetchMobileTakeHomeProject
//
//  Created by Crossley Rozario on 11/12/24.
//

import Foundation

protocol RecipeFetching {
    func fetchRecipes() async throws -> [RecipeModel]
}

enum RecipeServiceError: LocalizedError, Equatable {
    static func == (lhs: RecipeServiceError, rhs: RecipeServiceError) -> Bool {
        lhs.errorDescription == rhs.errorDescription
    }
    
    case invalidURL
    case networkError
    case decodingError(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The provided URL is invalid."
        case .networkError:
            return "There was an issue with the network request."
        case .decodingError(let error):
            return "Failed to decode the data: \(error.localizedDescription)"
        }
    }
}

enum RecipeURL: String {
    case recipes = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json"
    case malformedRecipes = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json"
    case emptyRecipes = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json"
}

class RecipeService: RecipeFetching {
    private let urlString = RecipeURL.recipes.rawValue
    private var session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }

    func fetchRecipes() async throws -> [RecipeModel] {
        guard let url = URL(string: urlString) else {
            throw RecipeServiceError.invalidURL
        }
        
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw RecipeServiceError.networkError
        }
        
        do {
            let recipes = try JSONDecoder().decode(RecipesModel.self, from: data).recipes
            return recipes
        } catch {
            throw RecipeServiceError.decodingError(error)
        }
    }
}
