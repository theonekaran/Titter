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
            print("login Error")
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
                        print("handleOpenURL Error")
                        self.loginFailure!(error)
                })
                
                
        }) { (error: NSError!) in
            print("handleOpenURL Error")
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
            print("homeTimeline Error")
            failure(error)
        })
    }
    
    func currentAccount(success: (User) -> (), failure: (NSError) -> ()) {
        GET("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            let userDictionary = response as? NSDictionary
            
            let user = User(dictionary: userDictionary!)
            success(user)
            
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) in
                print("Account info Error")
                failure(error)
        })
    }
    
    func statusUpdate(update: String, success: (Tweet) -> (), failure: (NSError) -> ()) {
        POST("1.1/statuses/update.json", parameters: ["status":update], progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            let tweet = Tweet(dictionary: response! as! NSDictionary)
            success(tweet)
            
        }) { (task: NSURLSessionDataTask?, error: NSError) in
            print("New Tweet Error")
            failure(error)
        }
    }
    
    func addFavorite(id: Int) {
        POST("1.1/favorites/create.json", parameters: ["id":id], progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
//            print(response)
        }) { (task: NSURLSessionDataTask?, error: NSError) in
                print("Add favorite error: \(error.localizedDescription)")
        }
    }
    
    func removeFavorite(id: Int) {
        POST("1.1/favorites/destroy.json", parameters: ["id":id], progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            //            print(response)
        }) { (task: NSURLSessionDataTask?, error: NSError) in
            print("Remove favorite error: \(error.localizedDescription)")
        }
    }
    
    func reTweet(id: Int) {
        POST("1.1/statuses/retweet/\(id).json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
//                        print(response)
        }) { (task: NSURLSessionDataTask?, error: NSError) in
            print("Retweet error: \(error.localizedDescription)")
        }
    }
    
    func unReTweet(id: Int) {
        var currentUserTweetID: String!
        getTweetInfo(id, includeRetweet: true, success: { (tweet: Tweet) in
            currentUserTweetID = tweet.currentUserReTweetID
            print("currentUserTweetID: \(currentUserTweetID)")
            print("TweetID: \(tweet.id)")
            self.POST("1.1/statuses/unretweet/\(currentUserTweetID).json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
                //            print(response)
            }) { (task: NSURLSessionDataTask?, error: NSError) in
                print("unReTweet error:" + error.localizedDescription)
            }
        }) { (error: NSError) in
                print(error.localizedDescription)
        }
        
        
    }
    
    func userTimeline(screenName: String, success: ([Tweet]) -> (), failure: (NSError) -> ()) {
        GET("1.1/statuses/user_timeline.json", parameters: ["screen_name":screenName], progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            let dictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries)
            success(tweets)
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) in
                print("homeTimeline Error")
                failure(error)
        })
    }
    
    
    func getTweetInfo(id: Int, includeRetweet: Bool, success: (Tweet) -> (), failure: (NSError) -> ()) {
        GET("1.1/statuses/show.json", parameters: ["id":id,"include_my_retweet": includeRetweet], progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            let tweet = Tweet(dictionary: response! as! NSDictionary)
            success(tweet)
        }) { (task: NSURLSessionDataTask?, error: NSError) in
                print("getTweetinfo Error")
                failure(error)
        }
    }
    
    
}
