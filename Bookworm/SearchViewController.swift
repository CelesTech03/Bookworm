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
    
    var searchResults = [BookItem]()
    var hasSearched = false
    var isLoading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // Makes Table View first row visible
        tableView.contentInset = UIEdgeInsets(top: 51, left: 0, bottom: 0, right: 0)
        
        // Code to register nibs
        // Search result nib
        var cellNib = UINib(nibName: TableView.CellIdentifiers.searchResultCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: TableView.CellIdentifiers.searchResultCell)
        // No results nib
        cellNib = UINib(nibName: TableView.CellIdentifiers.nothingFoundCell, bundle: nil)
        tableView.register(
            cellNib,
            forCellReuseIdentifier: TableView.CellIdentifiers.nothingFoundCell)
        // Loading nib
        cellNib = UINib(
            nibName: TableView.CellIdentifiers.loadingCell,
            bundle: nil)
        tableView.register(
            cellNib,
            forCellReuseIdentifier: TableView.CellIdentifiers.loadingCell)
    }
    
    struct TableView {
        struct CellIdentifiers {
            static let searchResultCell = "SearchResultCell"
            static let nothingFoundCell = "NothingFoundCell"
            static let loadingCell = "LoadingCell"
        }
    }
    
    // MARK: - Helper Methods
    func booksURL(searchText: String) -> URL {
        let encodedText = searchText.addingPercentEncoding(
            withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let urlString = String(
            format: "https://www.googleapis.com/books/v1/volumes?q="+searchText,
            encodedText)
        let url = URL(string: urlString)
        return url!
    }
    
    func parse(data: Data) -> [BookItem] {
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
    
    func performBookRequest(with url: URL) -> Data? {
        do {
            return try Data(contentsOf: url)
        } catch {
            print("Download Error: \(error.localizedDescription)")
            showNetworkError()
            return nil
        }
    }
    
    // Error handling
    func showNetworkError() {
        let alert = UIAlertController(
            title: "Whoops...",
            message: "There was an error accessing Google Books." +
            " Please try again.",
            preferredStyle: .alert)
        
        let action = UIAlertAction(
            title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}

// MARK: - Search Bar Delegate
extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if !searchBar.text!.isEmpty {
            searchBar.resignFirstResponder()
            
            isLoading = true
            tableView.reloadData()
            
            
            hasSearched = true
            searchResults = []
            // Makes web service requests asynchronous
            // Gets a reference to global queue
            let queue = DispatchQueue.global()
            let url = self.booksURL(searchText: searchBar.text!)
            // Dispatches a closure on queue. Code inside closure will be executed asynchronously
            queue.async {
                
                if let data = self.performBookRequest(with: url) {
                    self.searchResults = self.parse(data: data)
                    self.searchResults.sort(by: <)
                    
                    // Schedules a new closure on the main queue
                    DispatchQueue.main.async {
                        self.isLoading = false
                        self.tableView.reloadData()
                    }
                    return
                }
            }
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
        
        // If search is loading
        if isLoading {
            return 1
            // If no results
        } else if !hasSearched {
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
        
        // If search results is in the process of loading, show loading nib cell
        if isLoading {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: TableView.CellIdentifiers.loadingCell,
                for: indexPath)
            
            let spinner = cell.viewWithTag(100) as! UIActivityIndicatorView
            spinner.startAnimating()
            return cell
        } else
        // If no search results, return "No results" nib cell
        if searchResults.count == 0 {
            return tableView.dequeueReusableCell(
                withIdentifier: TableView.CellIdentifiers.nothingFoundCell,
                for: indexPath)
            // else, return search result nib cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier:
                                                        TableView.CellIdentifiers.searchResultCell,
                                                     for: indexPath) as! SearchResultCell
            
            let searchResult = searchResults[indexPath.row].volumeInfo
            cell.titleLabel.text = searchResult.title
            if searchResult.authors.isEmpty {
                cell.authorsLabel.text = "Unknown"
            } else {
                cell.authorsLabel.text = String(
                    format: "%@ (%@)",
                    searchResult.authors.joined(separator: ", "),
                    searchResult.publishedDate!)
            }
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
        
        // Disallows selecting no result or is loading cells
        if searchResults.count == 0 || isLoading {
            return nil
        } else {
            return indexPath
        }
    }
}
