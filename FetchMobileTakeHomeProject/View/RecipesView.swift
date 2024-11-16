//
//  RecipesView.swift
//  FetchMobileTakeHomeProject
//
//  Created by Crossley Rozario on 11/11/24.
//

import SwiftUI

struct RecipesView: View {
    @EnvironmentObject private var viewModel: RecipesViewModel
    
    var body: some View {
        NavigationStack {
            if !viewModel.recipes.isEmpty {
                List(viewModel.recipes, id: \.uuid) { recipe in
                    RecipeView(recipe: recipe)
                }
                .refreshable {
                    await viewModel.loadRecipes()
                }
                .navigationTitle("Recipes")
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        HStack {
                            Menu {
                                Picker(selection: $viewModel.sortOption) {
                                    ForEach(SortOption.allCases) { option in
                                        Text(String(describing: option))
                                    }
                                } label: {
                                    Image(systemName: "arrow.up.arrow.down.circle")
                                        .resizable()
                                        .frame(width: 24, height: 24)
                                }
                            } label: {
                                Image(systemName: "arrow.up.arrow.down.circle")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                            }
                            
                            Button(action: {
                                viewModel.isDarkMode.toggle()
                            }) {
                                Image(systemName: viewModel.isDarkMode ? "sun.max.fill" : "moon.fill")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                            }
                        }
                    }
                }
            } else {
                Text("No Recipes Found")
                    .font(.title)
            }
            
        }
    }
}

#Preview {
    RecipesView()
        .environmentObject(RecipesViewModel(recipeService: RecipeService()))
}
