//
//  AppDelegate.swift
//  Adaptive Flickr Search
//
//  Created by Errol Cheong on 2018-01-22.
//  Copyright © 2018 Errol Cheong. All rights reserved.
//

import UIKit

struct Constants {
    //Override these variables with your own api_key and shared_secret if not working.
    static let api_key = "aacf2aea79afde212979f5982da27eb8"
    static let shared_secret = "1035058bb32d5347"
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        
        var categories = [String]()
        if let url = Bundle.main.url(forResource: "Category", withExtension: "plist"),
            let plist = NSDictionary(contentsOf: url) as? [String: AnyObject],
            let data = plist["categories"] as? [String] {
            categories = data
        }
        
        if let splitViewController = window?.rootViewController as? UISplitViewController {
            splitViewController.delegate = self
            splitViewController.preferredDisplayMode = .allVisible
            
            if let masterNavController = splitViewController.viewControllers.first as? UINavigationController {
                if let masterViewController = masterNavController.topViewController as? FlickrTableViewController {
                    masterViewController.categories = categories
                }
            }
        }
        
        // Override point for customization after application launch.
        return true
    }
    
    
}

extension AppDelegate: UISplitViewControllerDelegate {
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return false
    }
    func splitViewController(_ splitViewController: UISplitViewController, separateSecondaryFrom primaryViewController: UIViewController) -> UIViewController? {
        
        if let navController = primaryViewController as? UINavigationController {
            return navController
        }
        
        return primaryViewController.storyboard?.instantiateViewController(withIdentifier: "NoCategorySelected")
    }
}
