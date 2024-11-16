//
//  RecipeView.swift
//  FetchMobileTakeHomeProject
//
//  Created by Crossley Rozario on 11/12/24.
//

import SwiftUI
import Kingfisher

struct RecipeView: View {
    @EnvironmentObject private var viewModel: RecipesViewModel
    @State private var showYouTubePlayer = false
    
    let recipe: RecipeModel
    let photoWidth: CGFloat = 80
    let photoHeight: CGFloat = 80
    let photoCornerRadius: CGFloat = 10
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            if let url = recipe.photoUrlSmall, let imageUrl = URL(string: url) {
                KFImage.url(imageUrl)
                    .placeholder {
                        ProgressView()
                    }
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: photoWidth, height: photoHeight)
                    .clipShape(RoundedRectangle(cornerRadius: photoCornerRadius))
                    .shadow(radius: 5)
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: photoWidth, height: photoHeight)
                    .foregroundColor(.gray)
                    .background(Color(.systemGray5))
                    .clipShape(RoundedRectangle(cornerRadius: photoCornerRadius))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(recipe.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(recipe.cuisine)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                if let youtubeURL = recipe.youtubeURL {
                    ZStack {
                        Button {
                            showYouTubePlayer.toggle()
                        } label: {
                            HStack {
                                Image(systemName: "play.rectangle.fill")
                                    .foregroundColor(.red)
                                Text("Watch on YouTube")
                                    .font(.subheadline)
                                    .foregroundColor(.blue)
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                        .sheet(isPresented: $showYouTubePlayer) {
                            YouTubePlayerView(url: youtubeURL, navigationTitle: recipe.name)
                        }
                    }
                }
            }
        }
        .padding(.vertical, 8)
        
    }
}

#Preview {
    RecipeView(recipe: RecipeModel(cuisine: "American", name: "Krispy Kreme Donut", photoUrlLarge: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/def8c76f-9054-40ff-8021-7f39148ad4b7/large.jpg", photoUrlSmall: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/def8c76f-9054-40ff-8021-7f39148ad4b7/small.jpg", uuid: "9e230f96-f93d-4d29-9230-a1f5fd539464", sourceURL: "https://www.mythirtyspot.com/krispy-kreme-copycat-recipe-for/", youtubeURL: "https://www.youtube.com/watch?v=SamYg6IUGOI"))
        .environmentObject(RecipesViewModel(recipeService: RecipeService()))
}
