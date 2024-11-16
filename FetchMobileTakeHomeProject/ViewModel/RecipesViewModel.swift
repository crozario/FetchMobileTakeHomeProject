//
//  RecipesViewModel.swift
//  FetchMobileTakeHomeProject
//
//  Created by Crossley Rozario on 11/12/24.
//

import SwiftUI

@MainActor
class RecipesViewModel: ObservableObject {
    @Published var isDarkMode: Bool = false
    @Published var recipes = [RecipeModel]()
    @Published var sortOption: SortOption = .nameAscending {
        didSet {
            sortRecipes(by: sortOption)
        }
    }
    
    private let recipeService: RecipeFetching
    
    init(recipeService: RecipeFetching) {
        self.recipeService = recipeService
        
        Task {
            await loadRecipes()
        }
    }
    
    private func sortRecipes(by option: SortOption) {
        switch option {
        case .nameAscending:
            recipes.sort { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
        case .nameDescending:
            recipes.sort { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedDescending }
        case .cuisineAscending:
            recipes.sort { $0.cuisine.localizedCaseInsensitiveCompare($1.cuisine) == .orderedAscending }
        case .cuisineDescending:
            recipes.sort { $0.cuisine.localizedCaseInsensitiveCompare($1.cuisine) == .orderedDescending }
        }
    }
    
    func loadRecipes() async {
        do {
            print("Fetching recipes")
            recipes = try await recipeService.fetchRecipes()
            sortRecipes(by: sortOption)
        } catch {
            print("Error fetching recipes: \(error)")
        }
    }
}


