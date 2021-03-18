//
//  AppDelegate.swift
//  BanyanDemo
//
//  Created by Shawn Frank on 16/02/2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    self.window = UIWindow(frame: UIScreen.main.bounds)
    let navController = UINavigationController()
    
    let rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "loginVC")
    navController.setViewControllers([rootVC], animated: true)
    window?.rootViewController = navController
    window?.makeKeyAndVisible()
    
    return true
  }
  
  internal func application(_ application: UIApplication,
                            open url: URL,
                            options: [UIApplication.OpenURLOptionsKey : Any] = [:] ) -> Bool {
    
    // Determine who sent the URL.
    let sendingAppID = options[.sourceApplication]
    print("source application = \(sendingAppID ?? "Unknown")")
    print("URL: \(url)")
    
    return true
  }
}

