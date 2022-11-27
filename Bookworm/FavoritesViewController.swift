//
//  FavoritesViewController.swift
//  Bookworm
//
//  Created by Celeste Urena on 11/5/22.
//

import UIKit

class FavoritesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var favBookList:NSMutableArray = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        if UserDefaults.standard.object(forKey: "favList") != nil {
            favBookList = NSMutableArray.init(array: UserDefaults.standard.object(forKey: "favList") as! NSArray)

            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func didReceiveMemoryWarning() {

        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.

    }
    
    // MARK: - Table View Delegate
    func tableView(
      _ tableView: UITableView,
      didSelectRowAt indexPath: IndexPath
    ) {
      tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favBookList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favCell", for: indexPath as IndexPath)
        
        cell.textLabel?.text = favBookList.object(at: indexPath.row) as? String
        
        return cell
    }
    
}
