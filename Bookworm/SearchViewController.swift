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
    var dataTask: URLSessionDataTask?
    
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
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Find selected book
//        let cell = sender as! UITableViewCell
//
//        let indexPath = tableView.indexPath(for: cell)!
//        let book = searchResults[indexPath.row].volumeInfo
//
//        // Pass selected book to the book details view controller
//        let detailsViewController = segue.destination as! BookDetailsViewController
//        detailsViewController.book = book
//
//        // Deselects row once tapped
//        tableView.deselectRow(at: indexPath, animated: true)
//    }
    
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
            
            dataTask?.cancel()
            isLoading = true
            tableView.reloadData()
            
            
            hasSearched = true
            searchResults = []
            
            // Makes web service requests asynchronous
            // Creates URL object
            let url = booksURL(searchText: searchBar.text!)
            // Get a shared URLSession instance
            let session = URLSession.shared
            // Creates a data task which are for fetching the contents of a given URL
            dataTask = session.dataTask(with: url)
            {data, response, error in
                // Error handling
                if let error = error as NSError?, error.code == -999 {
                    return  // Search was cancelled
                } else if let httpResponse = response as? HTTPURLResponse,
                          httpResponse.statusCode == 200 {
                    // Parses received JSON data
                    if let data = data {
                        self.searchResults = self.parse(data: data)
                        self.searchResults.sort(by: <)
                        DispatchQueue.main.async {
                            self.isLoading = false
                            self.tableView.reloadData()
                        }
                        return
                    }
                } else {
                    print("Failure! \(response!)")
                }
                DispatchQueue.main.async {
                    self.hasSearched = false
                    self.isLoading = false
                    self.tableView.reloadData()
                    self.showNetworkError()
                }
            }
            // Call resume() to start the data task
            dataTask?.resume()
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
            // Sets labels on search result cells
            cell.configure(for: searchResult)
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
