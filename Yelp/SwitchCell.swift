//
//  SwitchCell.swift
//  Yelp
//
//  Created by admin on 9/26/15.
//  Copyright © 2015 Timothy Lee. All rights reserved.
//

import UIKit

protocol SwitchCellDelegate: class {
    func switchCellDidToggle(cell: SwitchCell, newValue: Bool);
}

class SwitchCell: UITableViewCell {

    @IBOutlet weak var switchLabel: UILabel!;
    @IBOutlet weak var onSwitch: UISwitch!;
    
    weak var delegate: SwitchCellDelegate?;
    
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
    
    @IBAction func didToggleSwitch(sender: AnyObject) {
        delegate?.switchCellDidToggle(self, newValue: onSwitch.on);
    }

}
