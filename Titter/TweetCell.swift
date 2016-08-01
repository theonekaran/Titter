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
    
    var liked: Bool = false
    var retweeted: Bool = false
    
    
    let likeImageON = UIImage(named: "like-action-on")
    let likeImageOff = UIImage(named: "like-action-pressed")
    let retweetImageON = UIImage(named: "retweet-action-on")
    let retweetImageOff = UIImage(named: "retweet-action-pressed")
    
    var tweet: Tweet! {
        didSet{
            tweetLabel.text = tweet.text as? String
            userNameLabel.text = tweet.user?.name as? String
            screenNameLabel.text = tweet.user?.screenname! as? String
            let formatter = NSDateFormatter()
            formatter.dateFormat = "M/dd/yy"
            timeStampLabel.text = formatter.stringFromDate(tweet.timestamp!)
            profileImageView.setImageWithURL((tweet.user?.profileURL)!)
            
            if tweet.isFavorite == 1 {
                liked = true
                likeButton.setImage(likeImageON, forState: .Normal)
            } else {
                liked = false
            }
            
            if tweet.isRetweeted == 1 {
                retweeted = true
                reTweetButton.setImage(retweetImageON, forState: .Normal)
            } else {
                retweeted = false
            }
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
