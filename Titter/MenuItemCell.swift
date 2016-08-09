//
//  MenuItemCell.swift
//  Titter
//
//  Created by Karan Khurana on 8/8/16.
//  Copyright © 2016 Karan Khurana. All rights reserved.
//

import UIKit

class MenuItemCell: UITableViewCell {

    @IBOutlet weak var menuItemLabel: UILabel!
    
    var menuTitle: String! {
        didSet {
            menuItemLabel.text = menuTitle
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
