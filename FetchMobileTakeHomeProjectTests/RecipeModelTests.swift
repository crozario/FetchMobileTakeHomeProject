//
//  RecipeModelTests.swift
//  FetchMobileTakeHomeProjectTests
//
//  Created by Crossley Rozario on 11/15/24.
//

import XCTest
@testable import FetchMobileTakeHomeProject

final class RecipeModelTests: XCTestCase {
    
    let validRecipeJSON = """
    {
        "cuisine": "Malaysian",
        "name": "Apam Balik",
        "photo_url_large": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg",
        "photo_url_small": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg",
        "uuid": "599344f4-3c5c-4cca-b914-2210e3b3312f",
        "source_url": "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ",
        "youtube_url": "https://www.youtube.com/watch?v=6R8ffRRJcrg"
    }
    """.data(using: .utf8)!
    
    let invalidRecipeJSON = """
    {
        "cuisine": "Malaysian",
        "uuid": "599344f4-3c5c-4cca-b914-2210e3b3312f"
    }
    """.data(using: .utf8)!
    
    let validRecipesListJSON = """
    {
        "recipes": [
            {
                "cuisine": "Malaysian",
                "name": "Apam Balik",
                "photo_url_large": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg",
                "photo_url_small": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg",
                "uuid": "599344f4-3c5c-4cca-b914-2210e3b3312f",
                "source_url": "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ",
                "youtube_url": "https://www.youtube.com/watch?v=6R8ffRRJcrg"
            },
            {
                "cuisine": "British",
                "name": "Apple & Blackberry Crumble",
                "photo_url_large": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/large.jpg",
                "photo_url_small": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/small.jpg",
                "source_url": "https://www.bbcgoodfood.com/recipes/778642/apple-and-blackberry-crumble",
                "uuid": "599344f4-3c5c-4cca-b914-2210e3b3312f",
                "youtube_url": "https://www.youtube.com/watch?v=4vhcOwVBDO4"
            }
        ]
    }
    """.data(using: .utf8)!
    
    func testValidRecipeModelDecoding() throws {
        let decoder = JSONDecoder()
        let decodedRecipe = try decoder.decode(RecipeModel.self, from: validRecipeJSON)
        
        // Assert
        XCTAssertEqual(decodedRecipe.cuisine, "Malaysian")
        XCTAssertEqual(decodedRecipe.name, "Apam Balik")
        XCTAssertEqual(decodedRecipe.photoUrlLarge, "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg")
        XCTAssertEqual(decodedRecipe.photoUrlSmall, "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg")
        XCTAssertEqual(decodedRecipe.uuid, "599344f4-3c5c-4cca-b914-2210e3b3312f")
        XCTAssertEqual(decodedRecipe.sourceURL, "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ")
        XCTAssertEqual(decodedRecipe.youtubeURL, "https://www.youtube.com/watch?v=6R8ffRRJcrg")
    }
    
    func testInvalidRecipeModelDecoding() throws {
        let decoder = JSONDecoder()
        
        XCTAssertThrowsError(try decoder.decode(RecipeModel.self, from: invalidRecipeJSON)) { error in
            guard let decodingError = error as? DecodingError else {
                XCTFail("Unexpected error type: \(error)")
                return
            }
            
            switch decodingError {
            case .keyNotFound(let key, _):
                XCTAssertEqual(key.stringValue, "name", "Expected missing key: 'name', but got \(key.stringValue)")
            default:
                XCTFail("Unexpected decoding error: \(decodingError)")
            }
        }
    }
    
    func testValidRecipesModelDecoding() throws {
        let decoder = JSONDecoder()
        let decodedRecipesModel = try decoder.decode(RecipesModel.self, from: validRecipesListJSON)
        
        
        XCTAssertEqual(decodedRecipesModel.recipes.count, 2)
        
        let firstRecipe = decodedRecipesModel.recipes[0]
        XCTAssertEqual(firstRecipe.cuisine, "Malaysian")
        XCTAssertEqual(firstRecipe.name, "Apam Balik")
        
        let secondRecipe = decodedRecipesModel.recipes[1]
        XCTAssertEqual(secondRecipe.cuisine, "British")
        XCTAssertEqual(secondRecipe.name, "Apple & Blackberry Crumble")
    }
    
    func testEmptyRecipesList() throws {
        let emptyRecipesJSON = """
        {
            "recipes": []
        }
        """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        let decodedRecipesModel = try decoder.decode(RecipesModel.self, from: emptyRecipesJSON)
        
        XCTAssertEqual(decodedRecipesModel.recipes.count, 0)
    }
    
    func testOptionalFieldsInRecipeModel() throws {
        let missingFieldsJSON = """
        {
            "cuisine": "Malaysian",
            "name": "Apam Balik",
            "uuid": "599344f4-3c5c-4cca-b914-2210e3b3312f"
        }
        """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        let decodedRecipe = try decoder.decode(RecipeModel.self, from: missingFieldsJSON)
        
        XCTAssertEqual(decodedRecipe.cuisine, "Malaysian")
        XCTAssertEqual(decodedRecipe.name, "Apam Balik")
        XCTAssertEqual(decodedRecipe.uuid, "599344f4-3c5c-4cca-b914-2210e3b3312f")
        XCTAssertNil(decodedRecipe.photoUrlLarge)
        XCTAssertNil(decodedRecipe.photoUrlSmall)
        XCTAssertNil(decodedRecipe.sourceURL)
        XCTAssertNil(decodedRecipe.youtubeURL)
    }
}

