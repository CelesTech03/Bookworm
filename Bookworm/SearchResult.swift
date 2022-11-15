//
//  SearchResult.swift
//  Bookworm
//
//  Created by Celeste Urena on 11/14/22.
//

import Foundation

class ResultArray: Codable {
    var totalItems = 0
    var items = [SearchResult]()
}

class SearchResult: Codable {
    
    var authors: String? = ""
    var title: String? = ""
    
    var name: String {
        return title ?? ""
    }
}
