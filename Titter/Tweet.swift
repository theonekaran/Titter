//
//  Tweet.swift
//  Titter
//
//  Created by Karan Khurana on 7/29/16.
//  Copyright © 2016 Karan Khurana. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var text: NSString?
    var timestamp: NSDate?
    var retweetCount: Int = 0
    var favoritesCount: Int = 0
    var userName: NSString?
    var screenName: NSString?
    var profileImageURL: NSURL?
    var user: User!
    
    init(dictionary: NSDictionary) {
        text = dictionary["text"] as? String
        
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoritesCount = (dictionary["favourites_count"] as? Int) ?? 0
        
        let timeStampString = dictionary["created_at"] as? String
        if let timeStampString = timeStampString {
            let formatter = NSDateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timestamp = formatter.dateFromString(timeStampString)
        }
        
//        userName = dictionary["user"]!["name"] as? String
//        screenName = dictionary["user"]!["screen_name"] as? String
//        
//        let profileURLString = dictionary["user"]!["profile_image_url_https"] as? String
//        if let profileURLString = profileURLString {
//            profileImageURL = NSURL(string: profileURLString)
//        }
        
        user = User(dictionary: dictionary["user"]! as! NSDictionary)
        
    }
    
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            
            tweets.append(tweet)
        }
        
        
        return tweets
    }

}
