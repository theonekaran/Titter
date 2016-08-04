//
//  ProfileHeaderCell.swift
//  Titter
//
//  Created by Karan Khurana on 8/2/16.
//  Copyright © 2016 Karan Khurana. All rights reserved.
//

import UIKit

class ProfileHeaderCell: UITableViewCell {

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var tweetCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    
    var user: User! {
        didSet{
            userNameLabel.text = user.name as? String
            screenNameLabel.text = user.screenname as? String
            UIView.animateWithDuration(0.5) {
                self.profileImageView.setImageWithURL((self.user.profileURL)!)
                self.backgroundImageView.setImageWithURL((self.user.profileBackgroundURL)!)
            }
            followingCountLabel.text = String(user.followingCount)
            followersCountLabel.text = String(user.followersCount)
            tweetCountLabel.text = String(user.tweetCount)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layoutMargins = UIEdgeInsetsZero
        self.preservesSuperviewLayoutMargins = false
        profileImageView.layer.cornerRadius = 5
        profileImageView.clipsToBounds = true
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = backgroundImageView.bounds
        blurEffectView.alpha = 0.8
        blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight] // for supporting device rotation
        backgroundImageView.insertSubview(blurEffectView, atIndex: 0)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
