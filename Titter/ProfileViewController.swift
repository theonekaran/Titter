//
//  ProfileViewController.swift
//  Titter
//
//  Created by Karan Khurana on 8/2/16.
//  Copyright © 2016 Karan Khurana. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var tweets: [Tweet]!
    var headerSection: Int = 0
    var tweetsSection: Int = 1
    
    var senderTweet: Tweet!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.separatorInset = UIEdgeInsetsZero
        
        getTweets()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == headerSection {
            return 1
        } else {
            return tweets?.count ?? 0
        }
    }
    
    func tableView(tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        view.tintColor = UIColor.lightGrayColor()
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("ProfileHeaderCell", forIndexPath: indexPath) as! ProfileHeaderCell
            if senderTweet != nil {
                cell.user = senderTweet.user
            } else {
                cell.user = User.currentUser
            }
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier("ProfileTweetCell", forIndexPath: indexPath) as! ProfileTweetCell
            cell.tweet = tweets[indexPath.row]
            return cell
        } else {
            let cell = UITableViewCell()
            return cell
        }
    }
    
    func getTweets() {
        var screenName: String
        if senderTweet != nil {
            screenName = senderTweet.user.screenname! as String
        } else {
            screenName = User.currentUser?.screenname! as! String
        }
        TwitterClient.sharedInstance.userTimeline(screenName, success:  { (tweets: [Tweet]) in
            self.tweets = tweets
            self.tableView.reloadSections(NSIndexSet(index: self.tweetsSection), withRowAnimation: .None)
            }, failure: { (error: NSError) in
                print(error.localizedDescription)
        })
        
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
