//
//  ProfileViewController.swift
//  Titter
//
//  Created by Karan Khurana on 8/2/16.
//  Copyright © 2016 Karan Khurana. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, SegmentCellDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var tweets: [Tweet]!
    var headerSection: Int = 0
    var tweetsSection: Int = 2
    var segmentSection: Int = 1
    
    @IBOutlet weak var headerSegmentControl: UISegmentedControl!
    
    var senderTweet: Tweet!
    var senderScreenName: String!
    
    @IBOutlet weak var segmentView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.separatorInset = UIEdgeInsetsZero
        
        getUser()
        
        self.navigationItem.title = senderScreenName
        
        getTweets()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didSelectHeaderSection(sender: AnyObject) {
        if headerSegmentControl.selectedSegmentIndex == 0 {
            getTweets()
        } else if headerSegmentControl.selectedSegmentIndex == 2 {
            getMedia()
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == headerSection || section == segmentSection {
            return 1
        } else {
            return tweets?.count ?? 0
        }
    }
    
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == segmentSection {
            return 8
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == headerSection {
            let cell = tableView.dequeueReusableCellWithIdentifier("ProfileHeaderCell", forIndexPath: indexPath) as! ProfileHeaderCell
            if senderTweet != nil {
                cell.user = senderTweet.user
            } else {
                cell.user = User.currentUser
            }
            return cell
        } else if indexPath.section == segmentSection {
            let cell = tableView.dequeueReusableCellWithIdentifier("SegmentCell", forIndexPath: indexPath) as! SegmentCell
            cell.segmentIndex = headerSegmentControl.selectedSegmentIndex
            cell.delegate = self
            return cell
        } else if indexPath.section == tweetsSection {
            let cell = tableView.dequeueReusableCellWithIdentifier("ProfileTweetCell", forIndexPath: indexPath) as! ProfileTweetCell
            cell.tweet = tweets[indexPath.row]
            return cell
        }  else {
            let cell = UITableViewCell()
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func segmentCell(segmentCell: SegmentCell, didSelectSegment segment: Int) {
        segmentCell.segmentControl.selectedSegmentIndex = segment
        headerSegmentControl.selectedSegmentIndex = segment
        if segment == 0 {
            getTweets()
        } else if segment == 1 {
            getTweets()
        } else if segment == 2 {
            getMedia()
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 205 {
            segmentView.hidden = false
        } else {
            segmentView.hidden = true
        }
        
        if scrollView.contentOffset.y > 0 && scrollView.contentOffset.y < 40 {
            self.navigationController?.navigationBar
        }
    }
    
    func getUser() {
        if senderTweet != nil {
            senderScreenName = senderTweet.user.screenname! as String
        } else {
            senderScreenName = User.currentUser?.screenname! as! String
        }
    }
    
    func getMedia() {
        TwitterClient.sharedInstance.userLikes(senderScreenName, success: { (tweets: [Tweet]) in
            self.tweets = tweets
            self.tableView.reloadSections(NSIndexSet(index: self.tweetsSection), withRowAnimation: .None)
            self.tableView.reloadSections(NSIndexSet(index: self.segmentSection), withRowAnimation: .None)
        }) { (error: NSError) in
            print(error.localizedDescription)
        }
    }
    
    func getTweets() {
        TwitterClient.sharedInstance.userTimeline(senderScreenName, success:  { (tweets: [Tweet]) in
            self.tweets = tweets
            self.tableView.reloadSections(NSIndexSet(index: self.tweetsSection), withRowAnimation: .None)
            self.tableView.reloadSections(NSIndexSet(index: self.segmentSection), withRowAnimation: .None)
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
