//
//  TweetsViewController.swift
//  Titter
//
//  Created by Karan Khurana on 7/29/16.
//  Copyright © 2016 Karan Khurana. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NewTweetViewControllerDelegate, TweetCellDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var newTweetButton: UIBarButtonItem!
    
    var tweets: [Tweet]!
    
    let likeImageON = UIImage(named: "like-action-on")
    let likeImageOff = UIImage(named: "like-action-pressed")
    let retweetImageON = UIImage(named: "retweet-action-on")
    let retweetImageOff = UIImage(named: "retweet-action-pressed")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //initialize tableView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.separatorInset = UIEdgeInsetsZero
        
        // Initialize a UIRefreshControl
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        getTweets()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetCell
        cell.tweet = tweets[indexPath.row]
        cell.delegate = self
        if tweets[indexPath.row].isFavorite {
            cell.likeButton.setImage(likeImageON, forState: .Normal)
        } else {
            cell.likeButton.setImage(likeImageOff, forState: .Normal)
        }
        
        if tweets[indexPath.row].isRetweeted {
            cell.reTweetButton.setImage(retweetImageON, forState: .Normal)
        } else {
            cell.reTweetButton.setImage(retweetImageOff, forState: .Normal)
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tweetCell(tweetCell: TweetCell, didLike liked: Bool) {
        let indexPath = tableView.indexPathForCell(tweetCell)!
        if liked {
            TwitterClient.sharedInstance.addFavorite(tweets[indexPath.row].id)
            self.tweets[indexPath.row].isFavorite = true
            tableView.reloadData()
        } else {
            TwitterClient.sharedInstance.removeFavorite(tweets[indexPath.row].id)
            self.tweets[indexPath.row].isFavorite = false
            tableView.reloadData()
        }
    }
    
    func tweetCell(tweetCell: TweetCell, didRetweet retweeted: Bool) {
        let indexPath = tableView.indexPathForCell(tweetCell)!
        if retweeted {
            TwitterClient.sharedInstance.reTweet(tweets[indexPath.row].id)
            self.tweets[indexPath.row].isRetweeted = true
            tableView.reloadData()
        } else {
            TwitterClient.sharedInstance.unReTweet(tweets[indexPath.row].id)
            self.tweets[indexPath.row].isRetweeted = false
            tableView.reloadData()
        }
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        getTweets()
        refreshControl.endRefreshing()
    }
    
    func getTweets() {
        TwitterClient.sharedInstance.homeTimeline({ (tweets: [Tweet]) in
            self.tweets = tweets
            self.tableView.reloadData()
            }, failure: { (error: NSError) in
                print(error.localizedDescription)
        })
        
    }
    
    @IBAction func onLogOutButton(sender: AnyObject) {
        TwitterClient.sharedInstance.logout()
    }
    
    func tweetCell(tweetCell: TweetCell, didTapImage tapped: Bool) {
        performSegueWithIdentifier("HomeToProfile", sender: tweetCell)
    }
    
//    @IBAction func didTapProfileImage(sender: UITapGestureRecognizer) {
//        self.performSegueWithIdentifier("HomeToProfile", sender: self)
//        print(tableView.indexPathForRowAtPoint((sender.view?.center)!)!)
//    }
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "TweetViewtoNewTweet" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let newTweetViewController = navigationController.topViewController as! NewTweetViewController
            
            newTweetViewController.delegate = self
        } else if segue.identifier == "TweetDetail" {
            var tweet: Tweet!
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPathForCell(cell)
            tweet = tweets[indexPath!.row]
            let tweetDetailViewController = segue.destinationViewController as! TweetDetailViewController
            tweetDetailViewController.tweet = tweet
        } else if segue.identifier == "HomeToProfile" {
            let indexPath = tableView.indexPathForCell(sender as! UITableViewCell)
            var tweet: Tweet!
            tweet = tweets![indexPath!.row]
            let profileViewController = segue.destinationViewController as! ProfileViewController
            profileViewController.senderTweet = tweet
        }
    }
    
    func newTweetViewController(newTweetViewController: NewTweetViewController, didTweet tweet: Tweet) {
        self.tweets.insert(tweet, atIndex: 0)
        tableView.reloadData()
    }
 

}
