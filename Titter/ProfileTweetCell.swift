//
//  ProfileTweetCell.swift
//  Titter
//
//  Created by Karan Khurana on 8/2/16.
//  Copyright © 2016 Karan Khurana. All rights reserved.
//

import UIKit

@objc protocol ProfileTweetCellDelegate {
    optional func profileTweetCell(profileTweetCell: ProfileTweetCell, didLike liked: Bool)
    optional func profileTweetCell(profileTweetCell: ProfileTweetCell, didRetweet retweeted: Bool)
}

class ProfileTweetCell: UITableViewCell {

    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var reTweetButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    
    weak var delegate: ProfileTweetCellDelegate?
    
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
            timeStampLabel.text = tweet.timestamp?.timeAgoSimple()
            profileImageView.setImageWithURL((tweet.user?.profileURL)!)
            liked = tweet.isFavorite
            retweeted = tweet.isRetweeted
            
        }
    }
    @IBAction func didPressLikeButton(sender: AnyObject) {
        if liked {
            liked = false
        } else {
            liked = true
        }
        self.delegate?.profileTweetCell!(self, didLike: liked)
    }
    
    @IBAction func didPressRetweetButton(sender: AnyObject) {
        if retweeted {
            retweeted = false
        } else {
            retweeted = true
        }
        self.delegate?.profileTweetCell!(self, didRetweet: retweeted)
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
