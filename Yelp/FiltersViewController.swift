//
//  FiltersViewController.swift
//  Yelp
//
//  Created by Waghmare, Amol on 09/04/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol FiltersViewControllerDelegate {
    @objc optional func FiltersViewController(FiltersViewController : FiltersViewController, didUpdateFilters filters : [String: Any])
}

class FiltersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SimpleFilterCellDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    weak var delegate: FiltersViewControllerDelegate?
    
    var categories : [[String: String]]!
    var categorySwitch = [Int: Bool] ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        categories = getCategories()
        
        tableView.reloadData()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func onCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onSearch(_ sender: Any) {
        
        var filters = [String : Any]()
        
        var selectedCategories = [String]()
        for (row, isSelected) in categorySwitch {
            if (isSelected) {
                selectedCategories.append(categories[row]["code"]!)
            }
        }
        
        if selectedCategories.count > 0 {
            filters["categories"] = selectedCategories as Any
        }
        
        delegate?.FiltersViewController?(FiltersViewController: self, didUpdateFilters: filters)
        
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SimpleFilterCell", for: indexPath) as! SimpleFilterCell
        
        cell.filterLabel.text = categories[indexPath.row]["name"]
        cell.filterSwitch.isOn = categorySwitch[indexPath.row] ?? false
        cell.delegate = self
        return cell
        
    }
    
    func SimpleFilterCell(SimpleFilterCell: SimpleFilterCell, didChangeValue value: Bool) {
        let index = tableView.indexPath(for: SimpleFilterCell)
        
        //categories[index?.row]["isON"]
        categorySwitch[(index?.row)!] = value
    }
    
    func getCategories() -> [[String: String]] {
        return [
            ["name" : "Afghan", "code": "afaghani"],
            ["name" : "African", "code": "african"],
            ["name" : "vegan", "code": "vegan"],
        ]
    }

}
