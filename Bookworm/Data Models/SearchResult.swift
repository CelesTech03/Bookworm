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
    var items: [BookItem]
}

struct BookItem: Codable { 
    let volumeInfo: SearchResult
}

struct SearchResult: Codable {
    
    let title: String
    let categories: [String]?
    let authors: [String]?
    let publisher: String?
    let publishedDate: String?
    let description: String?
    let imageLinks: ImageLinks?
    
}

struct ImageLinks: Codable {
    let smallThumbnail, thumbnail: String
}
