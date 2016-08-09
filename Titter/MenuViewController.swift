//
//  MenuViewController.swift
//  Titter
//
//  Created by Karan Khurana on 8/8/16.
//  Copyright © 2016 Karan Khurana. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var tableHeaderSection: Int = 0
    var tableItemSection: Int = 1
    
    private var tweetsViewController: UIViewController!
    private var profileViewController: UIViewController!
    private var mentionsViewController: UIViewController!
    private var tweetsNavigationController: UIViewController!
    
    var viewControllers: [UIViewController] = []
    var viewControllerTitles = ["Home", "Profile", "Mention"]
    
    var hamburgerViewController: HamburgerViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //initialize table
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.separatorInset = UIEdgeInsetsZero
        
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        tweetsViewController = storyboard.instantiateViewControllerWithIdentifier("tweetsViewController")
        profileViewController = storyboard.instantiateViewControllerWithIdentifier("profileViewController")
        mentionsViewController = storyboard.instantiateViewControllerWithIdentifier("mentionsViewController")
        tweetsNavigationController = storyboard.instantiateViewControllerWithIdentifier("TweetsNavigationController") as! UINavigationController
        
        viewControllers.append(tweetsViewController)
        viewControllers.append(profileViewController)
        viewControllers.append(mentionsViewController)
        
//        let navigationController = hamburgerViewController.contentViewController.navigationController
//        navigationController.navigationBar.tintColor = UIColor.blueColor()
//        navigationController.viewControllers = viewControllers
//        navigationController.pushViewController(tweetsViewController, animated: true)
//
//        hamburgerViewController.contentViewController = UINavigationController(rootViewController: tweetsViewController)
//        hamburgerViewController.contentViewController.navigationController?.navigationBar.tintColor = UIColor.blueColor()
        hamburgerViewController.contentViewController = tweetsNavigationController
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == tableHeaderSection {
            return 1
        } else {
            return 3
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == tableHeaderSection {
            let cell = tableView.dequeueReusableCellWithIdentifier("MenuHeaderCell", forIndexPath: indexPath) as! MenuHeaderCell
            return cell
        } else if indexPath.section == tableItemSection {
            let cell = tableView.dequeueReusableCellWithIdentifier("MenuItemCell", forIndexPath: indexPath) as! MenuItemCell
            print("setting title")
            cell.menuTitle = viewControllerTitles[indexPath.row]
            return cell
        } else {
            let cell = UITableViewCell()
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
//        navigationController?.pushViewController(viewControllers[indexPath.row], animated: true)
        let tweetsRealNavigationController = tweetsNavigationController as! UINavigationController
        tweetsRealNavigationController.pushViewController(viewControllers[indexPath.row], animated: true)
        hamburgerViewController.contentViewController = tweetsRealNavigationController
        

        
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
