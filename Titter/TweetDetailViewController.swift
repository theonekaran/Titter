//
//  TweetDetailViewController.swift
//  Titter
//
//  Created by Karan Khurana on 7/31/16.
//  Copyright © 2016 Karan Khurana. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var tweetUserLabel: UILabel!
    @IBOutlet weak var tweetScreenNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var likesCountLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var replyButton: UIButton!
    
    var tweet: Tweet!
    var liked: Bool = false
    var retweeted: Bool = false

    
    let likeImageON = UIImage(named: "like-action-on")
    let likeImageOff = UIImage(named: "like-action-pressed")
    let retweetImageON = UIImage(named: "retweet-action-on")
    let retweetImageOff = UIImage(named: "retweet-action-pressed")

    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImageView.layer.cornerRadius = 3
        profileImageView.clipsToBounds = true
        profileImageView.setImageWithURL(tweet.user.profileURL!)
        tweetUserLabel.text = tweet.user.name as? String
        tweetScreenNameLabel.text =  tweet.user.screenname as? String
        tweetTextLabel.text = tweet.text as? String
        let formatter = NSDateFormatter()
        formatter.dateFormat = "M/dd/yy   hh:mm a"
        timeStampLabel.text = formatter.stringFromDate(tweet.timestamp!)
        retweetCountLabel.text = String(tweet.retweetCount)
        likesCountLabel.text = String(tweet.favoritesCount)
        
        if tweet.isFavorite {
            liked = true
            likeButton.setImage(likeImageON, forState: .Normal)
        } else {
            liked = false
        }
        
        if tweet.isRetweeted{
            retweeted = true
            retweetButton.setImage(retweetImageON, forState: .Normal)
        } else {
            retweeted = false
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didPressLikeButton(sender: AnyObject) {
        if liked {
            liked = false
            likeButton.setImage(likeImageOff, forState: .Normal)
            TwitterClient.sharedInstance.removeFavorite(tweet.id)
        } else {
            liked = true
            likeButton.setImage(likeImageON, forState: .Normal)
            TwitterClient.sharedInstance.addFavorite(tweet.id)
        }
    }

    @IBAction func didPressRetweetButton(sender: AnyObject) {
        if retweeted {
            retweeted = false
            retweetButton.setImage(retweetImageOff, forState: .Normal)
            
            TwitterClient.sharedInstance.unReTweet(tweet.id)
        } else {
            retweeted = true
            retweetButton.setImage(retweetImageON, forState: .Normal)
            print(tweet.id)
            TwitterClient.sharedInstance.reTweet(tweet.id)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
