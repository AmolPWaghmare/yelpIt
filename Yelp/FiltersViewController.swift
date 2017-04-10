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
    
    var deals : [[String: String]]!
    var dealsFilter: Bool = true
    
    var distance : [[String: String]]!
    var distanceIndex : Int = 0
    
    var sortBy : [[String: String]]!
    var sortIndex : Int = 0
    
    var categories : [[String: String]]!
    var categorySwitch = [Int: Bool] ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        deals = getDeals()
        distance = getDistance()
        sortBy = getSortBy()
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
        
        filters["deals"] = dealsFilter
        filters["distance"] = distance[distanceIndex]["code"]
        filters["sortBy"] = Int(sortBy[sortIndex]["code"]!)
        
        delegate?.FiltersViewController?(FiltersViewController: self, didUpdateFilters: filters)
        
        dismiss(animated: true, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch section {
            case 0:
                return "Deals"
            case 1:
                return "Distance"
            case 2:
                return "Sort By"
            case 3:
                return "Category"
            default:
                return ""
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case 0:
                return deals.count
            case 1:
                return distance.count
            case 2:
                return sortBy.count
            case 3:
                return categories.count
            default:
                return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SimpleFilterCell", for: indexPath) as! SimpleFilterCell
        
        switch indexPath.section {
            case 0:
                cell.filterLabel.text = deals[indexPath.row]["name"]
                cell.filterSwitch.isOn = dealsFilter
            case 1:
                cell.filterLabel.text = distance[indexPath.row]["name"]
                if distanceIndex == indexPath.row {
                    cell.filterSwitch.isOn = true
                } else {
                    cell.filterSwitch.isOn = false
                }
            case 2:
                cell.filterLabel.text = sortBy[indexPath.row]["name"]
                if sortIndex == indexPath.row {
                    cell.filterSwitch.isOn = true
                } else {
                    cell.filterSwitch.isOn = false
                }
            case 3:
                cell.filterLabel.text = categories[indexPath.row]["name"]
                cell.filterSwitch.isOn = categorySwitch[indexPath.row] ?? false
            default:
                cell.filterLabel.text = ""
                cell.filterSwitch.isOn = false
        }
        
        cell.delegate = self
        return cell
        
    }
    
    func SimpleFilterCell(SimpleFilterCell: SimpleFilterCell, didChangeValue value: Bool) {
        let index = tableView.indexPath(for: SimpleFilterCell)
        let section = (index?.section)!
        
        switch section {
            case 0:
                dealsFilter = value
            case 1:
                distanceIndex = (index?.row)!
            case 2:
                sortIndex = (index?.row)!
            case 3:
                categorySwitch[(index?.row)!] = value
            default:
                return
        }

    }
    
    func getDeals() -> [[String: String]] {
        return [
            ["name" : "Offering a Deal", "code": "true"]
        ]
    }
    
    func getDistance() -> [[String: String]] {
        return [
            ["name" : "Auto", "code": "afaghani"],
            ["name" : "0.3 miles", "code": "482"],
            ["name" : "1 mile", "code": "1609"],
            ["name" : "5 miles", "code": "8046"],
            ["name" : "20 miles", "code": "32186"],
        ]
    }
    
    func getSortBy() -> [[String: String]] {
        return [
            ["name" : "Best matched", "code": "0"],
            ["name" : "Distance", "code": "1"],
            ["name" : "Highest Rated", "code": "2"],
        ]
    }
    
    func getCategories() -> [[String: String]] {
        
        return [["name" : "Afghan", "code": "afghani"],
                          ["name" : "African", "code": "african"],
                          ["name" : "American, New", "code": "newamerican"],
                          ["name" : "American, Traditional", "code": "tradamerican"],
                          ["name" : "Arabian", "code": "arabian"],
                          ["name" : "Argentine", "code": "argentine"],
                          ["name" : "Armenian", "code": "armenian"],
                          ["name" : "Asian Fusion", "code": "asianfusion"],
                          ["name" : "Asturian", "code": "asturian"],
                          ["name" : "Australian", "code": "australian"],
                          ["name" : "Austrian", "code": "austrian"],
                          ["name" : "Baguettes", "code": "baguettes"],
                          ["name" : "Bangladeshi", "code": "bangladeshi"],
                          ["name" : "Barbeque", "code": "bbq"],
                          ["name" : "Basque", "code": "basque"],
                          ["name" : "Bavarian", "code": "bavarian"],
                          ["name" : "Beer Garden", "code": "beergarden"],
                          ["name" : "Beer Hall", "code": "beerhall"],
                          ["name" : "Beisl", "code": "beisl"],
                          ["name" : "Belgian", "code": "belgian"],
                          ["name" : "Bistros", "code": "bistros"],
                          ["name" : "Black Sea", "code": "blacksea"],
                          ["name" : "Brasseries", "code": "brasseries"],
                          ["name" : "Brazilian", "code": "brazilian"],
                          ["name" : "Breakfast & Brunch", "code": "breakfast_brunch"],
                          ["name" : "British", "code": "british"],
                          ["name" : "Buffets", "code": "buffets"],
                          ["name" : "Bulgarian", "code": "bulgarian"],
                          ["name" : "Burgers", "code": "burgers"],
                          ["name" : "Burmese", "code": "burmese"],
                          ["name" : "Cafes", "code": "cafes"],
                          ["name" : "Cafeteria", "code": "cafeteria"],
                          ["name" : "Cajun/Creole", "code": "cajun"],
                          ["name" : "Cambodian", "code": "cambodian"],
                          ["name" : "Canadian", "code": "New)"],
                          ["name" : "Canteen", "code": "canteen"],
                          ["name" : "Caribbean", "code": "caribbean"],
                          ["name" : "Catalan", "code": "catalan"],
                          ["name" : "Chech", "code": "chech"],
                          ["name" : "Cheesesteaks", "code": "cheesesteaks"],
                          ["name" : "Chicken Shop", "code": "chickenshop"],
                          ["name" : "Chicken Wings", "code": "chicken_wings"],
                          ["name" : "Chilean", "code": "chilean"],
                          ["name" : "Chinese", "code": "chinese"],
                          ["name" : "Comfort Food", "code": "comfortfood"],
                          ["name" : "Corsican", "code": "corsican"],
                          ["name" : "Creperies", "code": "creperies"],
                          ["name" : "Cuban", "code": "cuban"],
                          ["name" : "Curry Sausage", "code": "currysausage"],
                          ["name" : "Cypriot", "code": "cypriot"],
                          ["name" : "Czech", "code": "czech"],
                          ["name" : "Czech/Slovakian", "code": "czechslovakian"],
                          ["name" : "Danish", "code": "danish"],
                          ["name" : "Delis", "code": "delis"],
                          ["name" : "Diners", "code": "diners"],
                          ["name" : "Dumplings", "code": "dumplings"],
                          ["name" : "Eastern European", "code": "eastern_european"],
                          ["name" : "Ethiopian", "code": "ethiopian"],
                          ["name" : "Fast Food", "code": "hotdogs"],
                          ["name" : "Filipino", "code": "filipino"],
                          ["name" : "Fish & Chips", "code": "fishnchips"],
                          ["name" : "Fondue", "code": "fondue"],
                          ["name" : "Food Court", "code": "food_court"],
                          ["name" : "Food Stands", "code": "foodstands"],
                          ["name" : "French", "code": "french"],
                          ["name" : "French Southwest", "code": "sud_ouest"],
                          ["name" : "Galician", "code": "galician"],
                          ["name" : "Gastropubs", "code": "gastropubs"],
                          ["name" : "Georgian", "code": "georgian"],
                          ["name" : "German", "code": "german"],
                          ["name" : "Giblets", "code": "giblets"],
                          ["name" : "Gluten-Free", "code": "gluten_free"],
                          ["name" : "Greek", "code": "greek"],
                          ["name" : "Halal", "code": "halal"],
                          ["name" : "Hawaiian", "code": "hawaiian"],
                          ["name" : "Heuriger", "code": "heuriger"],
                          ["name" : "Himalayan/Nepalese", "code": "himalayan"],
                          ["name" : "Hong Kong Style Cafe", "code": "hkcafe"],
                          ["name" : "Hot Dogs", "code": "hotdog"],
                          ["name" : "Hot Pot", "code": "hotpot"],
                          ["name" : "Hungarian", "code": "hungarian"],
                          ["name" : "Iberian", "code": "iberian"],
                          ["name" : "Indian", "code": "indpak"],
                          ["name" : "Indonesian", "code": "indonesian"],
                          ["name" : "International", "code": "international"],
                          ["name" : "Irish", "code": "irish"],
                          ["name" : "Island Pub", "code": "island_pub"],
                          ["name" : "Israeli", "code": "israeli"],
                          ["name" : "Italian", "code": "italian"],
                          ["name" : "Japanese", "code": "japanese"],
                          ["name" : "Jewish", "code": "jewish"],
                          ["name" : "Kebab", "code": "kebab"],
                          ["name" : "Korean", "code": "korean"],
                          ["name" : "Kosher", "code": "kosher"],
                          ["name" : "Kurdish", "code": "kurdish"],
                          ["name" : "Laos", "code": "laos"],
                          ["name" : "Laotian", "code": "laotian"],
                          ["name" : "Latin American", "code": "latin"],
                          ["name" : "Live/Raw Food", "code": "raw_food"],
                          ["name" : "Lyonnais", "code": "lyonnais"],
                          ["name" : "Malaysian", "code": "malaysian"],
                          ["name" : "Meatballs", "code": "meatballs"],
                          ["name" : "Mediterranean", "code": "mediterranean"],
                          ["name" : "Mexican", "code": "mexican"],
                          ["name" : "Middle Eastern", "code": "mideastern"],
                          ["name" : "Milk Bars", "code": "milkbars"],
                          ["name" : "Modern Australian", "code": "modern_australian"],
                          ["name" : "Modern European", "code": "modern_european"],
                          ["name" : "Mongolian", "code": "mongolian"],
                          ["name" : "Moroccan", "code": "moroccan"],
                          ["name" : "New Zealand", "code": "newzealand"],
                          ["name" : "Night Food", "code": "nightfood"],
                          ["name" : "Norcinerie", "code": "norcinerie"],
                          ["name" : "Open Sandwiches", "code": "opensandwiches"],
                          ["name" : "Oriental", "code": "oriental"],
                          ["name" : "Pakistani", "code": "pakistani"],
                          ["name" : "Parent Cafes", "code": "eltern_cafes"],
                          ["name" : "Parma", "code": "parma"],
                          ["name" : "Persian/Iranian", "code": "persian"],
                          ["name" : "Peruvian", "code": "peruvian"],
                          ["name" : "Pita", "code": "pita"],
                          ["name" : "Pizza", "code": "pizza"],
                          ["name" : "Polish", "code": "polish"],
                          ["name" : "Portuguese", "code": "portuguese"],
                          ["name" : "Potatoes", "code": "potatoes"],
                          ["name" : "Poutineries", "code": "poutineries"],
                          ["name" : "Pub Food", "code": "pubfood"],
                          ["name" : "Rice", "code": "riceshop"],
                          ["name" : "Romanian", "code": "romanian"],
                          ["name" : "Rotisserie Chicken", "code": "rotisserie_chicken"],
                          ["name" : "Rumanian", "code": "rumanian"],
                          ["name" : "Russian", "code": "russian"],
                          ["name" : "Salad", "code": "salad"],
                          ["name" : "Sandwiches", "code": "sandwiches"],
                          ["name" : "Scandinavian", "code": "scandinavian"],
                          ["name" : "Scottish", "code": "scottish"],
                          ["name" : "Seafood", "code": "seafood"],
                          ["name" : "Serbo Croatian", "code": "serbocroatian"],
                          ["name" : "Signature Cuisine", "code": "signature_cuisine"],
                          ["name" : "Singaporean", "code": "singaporean"],
                          ["name" : "Slovakian", "code": "slovakian"],
                          ["name" : "Soul Food", "code": "soulfood"],
                          ["name" : "Soup", "code": "soup"],
                          ["name" : "Southern", "code": "southern"],
                          ["name" : "Spanish", "code": "spanish"],
                          ["name" : "Steakhouses", "code": "steak"],
                          ["name" : "Sushi Bars", "code": "sushi"],
                          ["name" : "Swabian", "code": "swabian"],
                          ["name" : "Swedish", "code": "swedish"],
                          ["name" : "Swiss Food", "code": "swissfood"],
                          ["name" : "Tabernas", "code": "tabernas"],
                          ["name" : "Taiwanese", "code": "taiwanese"],
                          ["name" : "Tapas Bars", "code": "tapas"],
                          ["name" : "Tapas/Small Plates", "code": "tapasmallplates"],
                          ["name" : "Tex-Mex", "code": "tex-mex"],
                          ["name" : "Thai", "code": "thai"],
                          ["name" : "Traditional Norwegian", "code": "norwegian"],
                          ["name" : "Traditional Swedish", "code": "traditional_swedish"],
                          ["name" : "Trattorie", "code": "trattorie"],
                          ["name" : "Turkish", "code": "turkish"],
                          ["name" : "Ukrainian", "code": "ukrainian"],
                          ["name" : "Uzbek", "code": "uzbek"],
                          ["name" : "Vegan", "code": "vegan"],
                          ["name" : "Vegetarian", "code": "vegetarian"],
                          ["name" : "Venison", "code": "venison"],
                          ["name" : "Vietnamese", "code": "vietnamese"],
                          ["name" : "Wok", "code": "wok"],
                          ["name" : "Wraps", "code": "wraps"],
                          ["name" : "Yugoslav", "code": "yugoslav"]]
        
    }

}
