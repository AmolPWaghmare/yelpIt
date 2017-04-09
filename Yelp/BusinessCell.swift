//
//  BusinessCell.swift
//  Yelp
//
//  Created by Waghmare, Amol on 08/04/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessCell: UITableViewCell {

    @IBOutlet weak var thumbImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!

    @IBOutlet weak var ratingsImageView: UIImageView!
    @IBOutlet weak var ratingsLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var tagsLabel: UILabel!
    
    var business : Business! {
        didSet {
            thumbImageView.setImageWith(business.imageURL!)
            
            nameLabel.text = business.name
            distanceLabel.text = business.distance
            
            ratingsImageView.setImageWith(business.ratingImageURL!)
            ratingsLabel.text = "\(business.reviewCount!) Reviews"
            
            addressLabel.text = business.address
            tagsLabel.text = business.categories
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        thumbImageView.layer.cornerRadius = 3
        thumbImageView.clipsToBounds = true
        
        nameLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        nameLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
