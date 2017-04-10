//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FiltersViewControllerDelegate, UISearchBarDelegate {
    
    var businesses: [Business]!
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        Business.searchWithTerm(term: "Restaurants", completion: { (businesses: [Business]?, error: Error?) -> Void in
                self.businesses = businesses
                self.tableView.reloadData()
            }
        )
        initSearchBar()
    }
    
    func initSearchBar() {
        let searchBar = UISearchBar();
        searchBar.showsCancelButton = false
        searchBar.delegate = self
        searchBar.placeholder = "Go, Yelp it!"
        self.navigationItem.titleView = searchBar
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if businesses != nil {
            return businesses!.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCell", for: indexPath) as! BusinessCell
        
        cell.business = businesses[indexPath.row]
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigationController = segue.destination as! UINavigationController
        
        let filtersViewController = navigationController.topViewController as! FiltersViewController
        
        filtersViewController.delegate = self
    }
    
    func FiltersViewController(FiltersViewController: FiltersViewController, didUpdateFilters filters: [String : Any]) {
        
        let selectedCategories = filters["categories"] as? [String]
        let isDeal = filters["deals"] as? Bool
        let sortBy = YelpSortMode(rawValue: filters["sortBy"] as! Int)
        
        Business.searchWithTerm(term: "Restaurants", sort : sortBy, categories: selectedCategories, deals: isDeal, completion: { (businesses: [Business]?, error: Error?) -> Void in
                    self.businesses = businesses
                    self.tableView.reloadData()
                }
            )
            
    }
    
}
