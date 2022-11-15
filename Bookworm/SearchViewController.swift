//
//  SearchViewController.swift
//  Bookworm
//
//  Created by Celeste Urena on 11/5/22.
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var searchResults = [SearchResult]()
    var hasSearched = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // Makes Table View first row visible
        tableView.contentInset = UIEdgeInsets(top: 51, left: 0, bottom: 0, right: 0)
        
        // Search result nib
        var cellNib = UINib(nibName: TableView.CellIdentifiers.searchResultCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: TableView.CellIdentifiers.searchResultCell)
        
        // No results nib
        cellNib = UINib(nibName: TableView.CellIdentifiers.nothingFoundCell, bundle: nil)
        tableView.register(
            cellNib,
            forCellReuseIdentifier: TableView.CellIdentifiers.nothingFoundCell)
    }
    
    struct TableView {
        struct CellIdentifiers {
            static let searchResultCell = "SearchResultCell"
            static let nothingFoundCell = "NothingFoundCell"
        }
    }
    
    // MARK: - Helper Methods
    func booksURL(searchText: String) -> URL {
        let encodedText = searchText.addingPercentEncoding(
            withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let urlString = String(
            format: "https://www.googleapis.com/books/v1/volumes?q=%@"+searchText+"&key=AIzaSyBSXB3F8Z32lv8xH23G93_7-xUTIli4oLA",
            encodedText)
        let url = URL(string: urlString)
        return url!
    }
    
    func performBookRequest(with url: URL) -> Data? {
        do {
            return try Data(contentsOf: url)
        } catch {
            print("Download Error: \(error.localizedDescription)")
            return nil
        }
    }
    
    func parse(data: Data) -> [SearchResult] {
        do {
            let decoder = JSONDecoder()
            let result = try decoder.decode(
                ResultArray.self, from: data)
            return result.items
        } catch {
            print("JSON Error: \(error)")
            return []
        }
    }
    
}

// MARK: - Search Bar Delegate
extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if !searchBar.text!.isEmpty {
            searchBar.resignFirstResponder()
            
            hasSearched = true
            searchResults = []
            
            let url = booksURL(searchText: searchBar.text!)
            print("URL: '\(url)'")
            
            if let data = performBookRequest(with: url) {
                let items = parse(data: data)
                print("Got results: '\(items)'")
            }
            tableView.reloadData()
        }
    }
    
    // Unifies status bar area with search bar
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}

// MARK: - Table View Delegate
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        if !hasSearched {
            return 0
        } else if searchResults.count == 0 {
            return 1
        } else {
            return searchResults.count
        }
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        
        // If no search results, return "No results" cell
        if searchResults.count == 0 {
            return tableView.dequeueReusableCell(
                withIdentifier: TableView.CellIdentifiers.nothingFoundCell,
                for: indexPath)
            // else, return search result cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier:
                                                        TableView.CellIdentifiers.searchResultCell,
                                                     for: indexPath) as! SearchResultCell
            
            let searchResult = searchResults[indexPath.row]
            cell.titleLabel.text = searchResult.title
            cell.authorsLabel.text = searchResult.authors
            return cell
        }
    }
    
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(
        _ tableView: UITableView,
        willSelectRowAt indexPath: IndexPath
    ) -> IndexPath? {
        if searchResults.count == 0 {
            return nil
        } else {
            return indexPath
        }
    }
}
