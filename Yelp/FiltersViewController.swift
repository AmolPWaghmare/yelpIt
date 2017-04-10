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
    
    var sectionsExpanded = [Int: Bool] ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        deals = getDeals()
        distance = getDistance()
        sortBy = getSortBy()
        categories = getCategories()
        
        sectionsExpanded[1] = false
        sectionsExpanded[2] = false
        
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        filters["distance"] = distance[distanceIndex]["distance"]
        filters["sortBy"] = Int(sortBy[sortIndex]["yelpCode"]!)
        
        delegate?.FiltersViewController?(FiltersViewController: self, didUpdateFilters: filters)
        
        dismiss(animated: true, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return getSectionData(section: section, row: 0)["titleForHeaderInSection"] as? String
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (getSectionData(section: section, row: 0)["numberOfRowsInSection"] as? Int)!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = indexPath.section
        let row = indexPath.row
        return getSectionData(section: section, row: row)["heightForRowAt"] as! CGFloat
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SimpleFilterCell", for: indexPath) as! SimpleFilterCell
        
        let section = indexPath.section
        let row = indexPath.row
        let sectionData = getSectionData(section: section, row: row)
        cell.filterLabel.text = sectionData["cellForRowAt_Text"] as? String
        cell.filterSwitch.isOn = (sectionData["cellForRowAt_Switch"] as? Bool)!
        
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Expand Section
        sectionsExpanded[indexPath.section] = true
        tableView.reloadSections(IndexSet(integer: indexPath.section), with: .automatic)
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
        
        //Collapse Section
        sectionsExpanded[section] = false
        tableView.reloadSections(IndexSet(integer: section), with: .automatic)
    }
    
    func getSectionData(section: Int, row: Int) -> [String : Any] {
        var sectionObj = [String : Any]()
        
        switch section {
            case 0:
                sectionObj["numberOfRowsInSection"] = deals.count
                sectionObj["titleForHeaderInSection"] = nil
                sectionObj["heightForRowAt"] = UITableViewAutomaticDimension
                sectionObj["cellForRowAt_Text"] = deals[row]["name"]
                sectionObj["cellForRowAt_Switch"] = dealsFilter
            
            case 1:
                sectionObj["numberOfRowsInSection"] = distance.count
                sectionObj["titleForHeaderInSection"] = "Distance"
                
                if (sectionsExpanded[section] == false && distanceIndex != row) {
                    sectionObj["heightForRowAt"] = CGFloat(0.0)
                } else {
                    sectionObj["heightForRowAt"] = UITableViewAutomaticDimension
                }
                sectionObj["cellForRowAt_Text"] = distance[row]["name"]
                
                if distanceIndex == row {
                    sectionObj["cellForRowAt_Switch"] = true
                } else {
                    sectionObj["cellForRowAt_Switch"] = false
                }
            
            case 2:
                sectionObj["numberOfRowsInSection"] = sortBy.count
                sectionObj["titleForHeaderInSection"] = "Sort By"
                
                if (sectionsExpanded[section] == false && sortIndex != row) {
                    sectionObj["heightForRowAt"] = CGFloat(0.0)
                } else {
                    sectionObj["heightForRowAt"] = UITableViewAutomaticDimension
                }
                sectionObj["cellForRowAt_Text"] = sortBy[row]["name"]
                
                if sortIndex == row {
                    sectionObj["cellForRowAt_Switch"] = true
                } else {
                    sectionObj["cellForRowAt_Switch"] = false
                }
            
            case 3:
                sectionObj["numberOfRowsInSection"] = categories.count
                sectionObj["titleForHeaderInSection"] = "Category"
                sectionObj["heightForRowAt"] = UITableViewAutomaticDimension
                sectionObj["cellForRowAt_Text"] = categories[row]["name"]
                sectionObj["cellForRowAt_Switch"] = categorySwitch[row] ?? false
            
            default:
                sectionObj["numberOfRowsInSection"] = 0
                sectionObj["titleForHeaderInSection"] = nil
                sectionObj["heightForRowAt"] = UITableViewAutomaticDimension
                sectionObj["cellForRowAt_Text"] = ""
                sectionObj["cellForRowAt_Switch"] = false
        }
        
        return sectionObj
    }
    
    func getDeals() -> [[String: String]] {
        return [
            ["name" : "Offering a Deal", "code": "true"]
        ]
    }
    
    func getDistance() -> [[String: String]] {
        return [
            ["name" : "Auto",       "distance": "0"],
            ["name" : "0.3 miles",  "distance": "482"],
            ["name" : "1 mile",     "distance": "1609"],
            ["name" : "5 miles",    "distance": "8046"],
            ["name" : "20 miles",   "distance": "32186"],
        ]
    }
    
    func getSortBy() -> [[String: String]] {
        return [
            ["name" : "Best matched",   "yelpCode": "0"],
            ["name" : "Distance",       "yelpCode": "1"],
            ["name" : "Highest Rated",  "yelpCode": "2"],
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
