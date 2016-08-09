//
//  SegmentCell.swift
//  Titter
//
//  Created by Karan Khurana on 8/4/16.
//  Copyright © 2016 Karan Khurana. All rights reserved.
//

import UIKit

@objc protocol SegmentCellDelegate {
    optional func segmentCell(segmentCell : SegmentCell, didSelectSegment segment: Int)
}

class SegmentCell: UITableViewCell {

    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    var segmentIndex: Int = 0 {
        didSet {
            segmentControl.selectedSegmentIndex = segmentIndex
        }
    }
    
    weak internal var delegate: SegmentCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func didTapSegment(sender: AnyObject) {
        delegate?.segmentCell!(self, didSelectSegment: segmentControl.selectedSegmentIndex)
    }
}
