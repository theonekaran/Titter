//
//  TwitterClient.swift
//  Titter
//
//  Created by Karan Khurana on 7/29/16.
//  Copyright © 2016 Karan Khurana. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    
    static let sharedInstance = TwitterClient(baseURL: NSURL(string: "https://api.twitter.com")!, consumerKey: "eb2cC3UOQPgJbe5hTFb2n7ioV", consumerSecret: "Wiwo0mNJtfd5cSHfdQqT46whXt0kNpXtIxnxbAcrNCukpEKxbj")
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((NSError) -> ())?
    
    func login(success: () -> (), failure: (NSError) -> ()) {
        loginSuccess = success
        loginFailure = failure
        
        TwitterClient.sharedInstance.deauthorize()
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "titter://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) in
            let url = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")!
            UIApplication.sharedApplication().openURL(url)
        }) { (error: NSError!) in
            self.loginFailure?(error)
        }
    }
    
    func handleOpenURL(url: NSURL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessTokenWithPath("oauth/access_token"
            , method: "POST", requestToken: requestToken, success: { (accessToken:BDBOAuth1Credential!) in
                
                self.currentAccount({ (user: User) in
                    User.currentUser = user
                    self.loginSuccess?()
                    
                    }, failure: { (error: NSError) in
                        self.loginFailure!(error)
                })
                
                
        }) { (error: NSError!) in
            self.loginFailure!(error)
        }

    }
    
    func logout() {
        User.currentUser = nil
        deauthorize()
        
        NSNotificationCenter.defaultCenter().postNotificationName(User.userDidLogoutNotification, object: nil)
        
    }
    
    
    func homeTimeline(success: ([Tweet]) -> (), failure: (NSError) -> ()) {
        GET("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            let dictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries)
            success(tweets)
        }, failure: { (task: NSURLSessionDataTask?, error: NSError) in
            failure(error)
        })
    }
    
    func currentAccount(success: (User) -> (), failure: (NSError) -> ()) {
        GET("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            let userDictionary = response as? NSDictionary
            
            let user = User(dictionary: userDictionary!)
            success(user)
            
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) in
                failure(error)
        })
    }
    
    func statusUpdate(update: String, success: (Tweet) -> (), failure: (NSError) -> ()) {
        POST("1.1/statuses/update.json", parameters: ["status":update], progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            let tweet = Tweet(dictionary: response! as! NSDictionary)
            success(tweet)
            
        }) { (task: NSURLSessionDataTask?, error: NSError) in
                failure(error)
        }
    }
    
    
}
