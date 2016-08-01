//
//  NewTweetViewController.swift
//  Titter
//
//  Created by Karan Khurana on 7/31/16.
//  Copyright © 2016 Karan Khurana. All rights reserved.
//

import UIKit

@objc protocol newTweetViewControllerDelegate {
    optional func NewTweetViewController(newTweetViewController: NewTweetViewController, didTweet tweet: Tweet)
}

class NewTweetViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var tweetTextView: UITextView!
    @IBOutlet weak var tweetCountButton: UIBarButtonItem!
    var tweet: Tweet!
    
    weak var delegate: newTweetViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImageView.setImageWithURL((User.currentUser?.profileURL)!)
        userNameLabel.text = User.currentUser?.name as? String
        screenNameLabel.text =  "@" + ((User.currentUser?.screenname)! as String)
        
        tweetTextView.becomeFirstResponder()
        tweetTextView.delegate = self
        
        
    }
    
    
//    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
//        let newLength = textView.text.characters.count
//        tweetCountButton.title = String(newLength)
//    }

    func textViewDidChange(textView: UITextView) {
        let newLength = 140 - textView.text.characters.count
        tweetCountButton.title = String(newLength)
    }
    
    @IBAction func didTweetButton(sender: AnyObject) {
        TwitterClient.sharedInstance.statusUpdate((tweetTextView.text), success: { (tweet: Tweet) in
            self.tweet = tweet
            self.dismissViewControllerAnimated(true, completion: nil)
            delegate?.NewTweetViewController?(self, didTweet: self.tweet)
        }) { (error: NSError) in
                print(error.localizedDescription)
        }
    }

    @IBAction func didCancelButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
