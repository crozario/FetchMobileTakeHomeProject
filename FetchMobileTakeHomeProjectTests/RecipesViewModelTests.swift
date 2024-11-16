//
//  RecipesViewModelTests.swift
//  FetchMobileTakeHomeProjectTests
//
//  Created by Crossley Rozario on 11/15/24.
//

import XCTest
@testable import FetchMobileTakeHomeProject

@MainActor
final class RecipesViewModelTests: XCTestCase {
    var mockRecipeService: MockRecipeService!
    var viewModel: RecipesViewModel!
    
    override func setUp() {
        super.setUp()
        mockRecipeService = MockRecipeService()
        mockRecipeService.mockRecipes = [
            RecipeModel(cuisine: "Malaysian", name: "Apam Balik", photoUrlLarge: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg", photoUrlSmall: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg", uuid: "599344f4-3c5c-4cca-b914-2210e3b3312f", sourceURL: "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ", youtubeURL: "https://www.youtube.com/watch?v=6R8ffRRJcrg"),
            RecipeModel(cuisine: "British", name: "Apple & Blackberry Crumble", photoUrlLarge: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/large.jpg", photoUrlSmall: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/small.jpg", uuid: "599344f4-3c5c-4cca-b914-2210e3b3312f", sourceURL: nil, youtubeURL: "https://www.youtube.com/watch?v=4vhcOwVBDO4")
        ]
        
        viewModel = RecipesViewModel(recipeService: mockRecipeService)
    }
    
    override func tearDown() {
        mockRecipeService = nil
        viewModel = nil
        super.tearDown()
    }

    func testLoadRecipes() async {
        await viewModel.loadRecipes()

        XCTAssertEqual(viewModel.recipes.count, 2, "ViewModel should load two recipes.")
        XCTAssertEqual(viewModel.recipes.first?.name, "Apam Balik", "First recipe should be Apam Balik.")
    }
    
    func testHandleEmptyRecipes() async {
        mockRecipeService.mockRecipes = []
        await viewModel.loadRecipes()

        XCTAssertEqual(viewModel.recipes.count, 0, "ViewModel should handle empty recipes correctly.")
    }
    
    func testSortRecipesByNameAscending() async {
        await viewModel.loadRecipes()
        viewModel.sortOption = .nameAscending
        
        XCTAssertEqual(viewModel.recipes.first?.name, "Apam Balik", "Recipes should be sorted by name in ascending order.")
    }
    
    func testSortRecipesByNameDescending() async {
        await viewModel.loadRecipes()
        viewModel.sortOption = .nameDescending

        XCTAssertEqual(viewModel.recipes.first?.name, "Apple & Blackberry Crumble", "Recipes should be sorted by name in descending order.")
    }
    
    func testSortRecipesByCuisineAscending() async {
        await viewModel.loadRecipes()
        viewModel.sortOption = .cuisineAscending

        XCTAssertEqual(viewModel.recipes.first?.cuisine, "British", "Recipes should be sorted by cuisine in ascending order.")
    }
    
    func testSortRecipesByCuisineDescending() async {
        await viewModel.loadRecipes()
        viewModel.sortOption = .cuisineDescending
        
        XCTAssertEqual(viewModel.recipes.first?.cuisine, "Malaysian", "Recipes should be sorted by cuisine in descending order.")
    }
    
    func testSortConsistencyAfterAddingRecipes() async {
        await viewModel.loadRecipes()
        viewModel.sortOption = .nameAscending

        let newRecipe = RecipeModel(cuisine: "American", name: "Banana Pancakes", photoUrlLarge: nil, photoUrlSmall: nil, uuid: "f8b20884-1e54-4e72-a417-dabbc8d91f12", sourceURL: nil, youtubeURL: nil)
        viewModel.recipes.append(newRecipe)
        viewModel.sortOption = .nameAscending

        XCTAssertEqual(viewModel.recipes.first?.name, "Apam Balik", "Recipes should still be sorted correctly after adding a new recipe.")
    }
    
    func testDarkModeToggle() {
        XCTAssertFalse(viewModel.isDarkMode, "Dark mode should be off by default.")
        
        viewModel.isDarkMode.toggle()
        XCTAssertTrue(viewModel.isDarkMode, "Dark mode should be enabled after toggling.")
        
        viewModel.isDarkMode.toggle()
        XCTAssertFalse(viewModel.isDarkMode, "Dark mode should be off after second toggle.")
    }

}


final class MockRecipeService: RecipeFetching {
    var mockRecipes: [RecipeModel] = []
    
    func fetchRecipes() async throws -> [RecipeModel] {
        return mockRecipes
    }
}
