//
//  AppDelegate.swift
//  GitUser
//
//  Created by Jan Sebastian on 20/09/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let rootPage = UINavigationController(rootViewController: ListUserViewController())
        rootPage.navigationBar.isHidden = true
        self.window?.rootViewController = rootPage
        self.window?.makeKeyAndVisible()
        
        return true
    }

    


}

