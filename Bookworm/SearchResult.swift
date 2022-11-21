//
//  SearchResult.swift
//  Bookworm
//
//  Created by Celeste Urena on 11/14/22.
//

import Foundation

func < (lhs: BookItem, rhs: BookItem) -> Bool {
    return lhs.volumeInfo.title.localizedStandardCompare(rhs.volumeInfo.title) == .orderedAscending
}

struct ResultArray: Codable {
    var totalItems = 0
    var items: [BookItem]
}

struct BookItem: Codable {
    //    var id: String
    let volumeInfo: SearchResult
}

struct SearchResult: Codable {
    
    let title: String
    let subtitle: String?
    let authors: [String]
    let publisher: String?
    let publishedDate: String?
    let description: String?
    let pageCount: Int?
    let averageRating: Double?
    let imageLinks: ImageLinks
    
}

struct ImageLinks: Codable {
    let smallThumbnail, thumbnail: String
}
