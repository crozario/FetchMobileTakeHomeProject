//
//  FetchMobileTakeHomeProjectApp.swift
//  FetchMobileTakeHomeProject
//
//  Created by Crossley Rozario on 11/11/24.
//

import SwiftUI

@main
struct FetchMobileTakeHomeProjectApp: App {
    @StateObject var recipesViewModel = RecipesViewModel(recipeService: RecipeService())
    
    var body: some Scene {
        WindowGroup {
            RecipesView()
                .preferredColorScheme(recipesViewModel.isDarkMode ? .dark : .light)
                .environmentObject(recipesViewModel)
        }
    }
}
