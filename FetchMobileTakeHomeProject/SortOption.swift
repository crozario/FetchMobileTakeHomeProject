//
//  SortOption.swift
//  FetchMobileTakeHomeProject
//
//  Created by Crossley Rozario on 11/15/24.
//

import Foundation

enum SortOption: CaseIterable, Identifiable, CustomStringConvertible {
    case nameAscending
    case nameDescending
    case cuisineAscending
    case cuisineDescending
    
    var id: Self { self }
    
    var description: String {
        switch self {
        case .nameAscending:
            return "Sort by Name (A-Z)"
        case .nameDescending:
            return "Sort by Name (Z-A)"
        case .cuisineAscending:
            return "Sort by Cuisine (A-Z)"
        case .cuisineDescending:
            return "Sort by Cuisine (Z-A)"
        }
    }
}
