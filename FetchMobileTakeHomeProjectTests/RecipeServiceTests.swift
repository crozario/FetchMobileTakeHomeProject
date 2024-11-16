//
//  RecipeServiceTests.swift
//  FetchMobileTakeHomeProjectTests
//
//  Created by Crossley Rozario on 11/15/24.
//

import XCTest
@testable import FetchMobileTakeHomeProject

class RecipeServiceTests: XCTestCase {
    class MockURLProtocol: URLProtocol {
        static var stubResponseData: Data?
        static var error: Error?
        static var response: URLResponse?
        
        override class func canInit(with request: URLRequest) -> Bool {
            return true
        }
        
        override class func canonicalRequest(for request: URLRequest) -> URLRequest {
            return request
        }
        
        override func startLoading() {
            if let error = MockURLProtocol.error {
                self.client?.urlProtocol(self, didFailWithError: error)
            } else {
                if let response = MockURLProtocol.response {
                    self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
                }
                
                if let data = MockURLProtocol.stubResponseData {
                    self.client?.urlProtocol(self, didLoad: data)
                }
                
                self.client?.urlProtocolDidFinishLoading(self)
            }
        }
        
        override func stopLoading() {}
    }
    
    var recipeService: RecipeService!
    var session: URLSession!
    
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
    
    let emptyJSON = """
    {
        "recipes": []
    }
    """.data(using: .utf8)!
    
    
    override func setUp() {
        super.setUp()
        
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        session = URLSession(configuration: config)
        recipeService = RecipeService(session: session)
    }
    
    override func tearDown() {
        recipeService = nil
        session = nil
        MockURLProtocol.stubResponseData = nil
        MockURLProtocol.error = nil
        MockURLProtocol.response = nil
        super.tearDown()
    }
    
    func testFetchRecipesSuccessfully() async throws {
        MockURLProtocol.stubResponseData = validRecipesListJSON
        MockURLProtocol.response = HTTPURLResponse(url: URL(string: RecipeURL.recipes.rawValue)!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        let recipes = try await recipeService.fetchRecipes()
        
        XCTAssertEqual(recipes.count, 2)
        XCTAssertEqual(recipes.first?.name, "Apam Balik")
    }
    
    func testFetchRecipesNetworkError() async {
        MockURLProtocol.response = HTTPURLResponse(url: URL(string: RecipeURL.recipes.rawValue)!, statusCode: 400, httpVersion: nil, headerFields: nil)
        
        do {
            _ = try await recipeService.fetchRecipes()
            XCTFail("Expected to throw an error but did not throw")
        } catch {
            XCTAssertEqual(error as? RecipeServiceError, RecipeServiceError.networkError)
        }
    }
    
    func testFetchRecipesDecodingError() async {
        let invalidJsonString = """
        { 
            "invalid": "data"
        }
        """.data(using: .utf8)!

        MockURLProtocol.stubResponseData = invalidJsonString
        MockURLProtocol.response = HTTPURLResponse(url: URL(string: RecipeURL.malformedRecipes.rawValue)!, statusCode: 200, httpVersion: nil, headerFields: nil)

        do {
            _ = try await recipeService.fetchRecipes()
            XCTFail("Expected to throw an error but did not throw")
        } catch {
            if case RecipeServiceError.decodingError(_) = error {
                XCTAssertTrue(true)
            } else {
                XCTFail("Expected decodingError, got \(error)")
            }
        }
    }
    
    func testFetchRecipesEmptyResponse() async throws {
        MockURLProtocol.stubResponseData = emptyJSON
        MockURLProtocol.response = HTTPURLResponse(url: URL(string: RecipeURL.emptyRecipes.rawValue)!, statusCode: 200, httpVersion: nil, headerFields: nil)
        

        let recipes = try await recipeService.fetchRecipes()

        XCTAssertEqual(recipes.count, 0)
    }
}
