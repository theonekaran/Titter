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
    var isFavorite: Bool = false
    var isRetweeted: Bool = false
    var user: User!
    var id: Int = 0
    var currentUserReTweetID: String!
    
    init(dictionary: NSDictionary) {
        text = dictionary["text"] as? String
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        isRetweeted = (dictionary["retweeted"] as? Bool)!
//        print(isRetweeted)
        favoritesCount = (dictionary["favorite_count"] as? Int) ?? 0
        isFavorite = (dictionary["favorited"] as? Bool)!
//        print(isFavorite)
        let timeStampString = dictionary["created_at"] as? String
        if let timeStampString = timeStampString {
            let formatter = NSDateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timestamp = formatter.dateFromString(timeStampString)
        }
        
        id = (dictionary["id"] as? Int)!
        
        user = User(dictionary: dictionary["user"]! as! NSDictionary)
        
        if dictionary["current_user_retweet"] != nil {
            currentUserReTweetID = dictionary["current_user_retweet"]!["id_str"]! as! String
        }
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
