//
//  SingleChoiceCell.swift
//  Yelp
//
//  Created by admin on 9/27/15.
//  Copyright © 2015 Timothy Lee. All rights reserved.
//

import UIKit

class SingleChoiceCell: UITableViewCell {

    @IBOutlet weak var preferenceLabel: UILabel!
    @IBOutlet weak var checkMarkImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib();
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse();
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setCheckMarkSelected(selected: Bool) {
        self.checkMarkImageView.hidden = !selected;
    }
}
