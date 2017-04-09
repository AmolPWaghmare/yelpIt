//
//  SimpleFilterCell.swift
//  Yelp
//
//  Created by Waghmare, Amol on 09/04/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol SimpleFilterCellDelegate {
    @objc optional func SimpleFilterCell(SimpleFilterCell : SimpleFilterCell, didChangeValue  value: Bool)
}

class SimpleFilterCell: UITableViewCell {

    @IBOutlet weak var filterSwitch: UISwitch!
    @IBOutlet weak var filterLabel: UILabel!
    
    weak var delegate: SimpleFilterCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func onSwitch(_ sender: Any) {
        delegate?.SimpleFilterCell?(SimpleFilterCell: self, didChangeValue: filterSwitch.isOn)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
