//
//  TweetCell.swift
//  Titter
//
//  Created by Karan Khurana on 7/29/16.
//  Copyright © 2016 Karan Khurana. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {

    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var reTweetButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    
    var tweet: Tweet! {
        didSet{
            tweetLabel.text = tweet.text as? String
            userNameLabel.text = tweet.user?.name as? String
            screenNameLabel.text = "@\((tweet.user?.screenname! as? String)!)"
            let formatter = NSDateFormatter()
            formatter.dateFormat = "M/dd/yy"
            timeStampLabel.text = formatter.stringFromDate(tweet.timestamp!)
            profileImageView.setImageWithURL((tweet.user?.profileURL)!)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layoutMargins = UIEdgeInsetsZero
        self.preservesSuperviewLayoutMargins = false
        profileImageView.layer.cornerRadius = 3
        profileImageView.clipsToBounds = true
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
