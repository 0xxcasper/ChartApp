//
//  AppDelegate.swift
//  System Utilities
//

import UIKit
//import ChameleonFramework

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    private func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        UINavigationBar.appearance().barTintColor = .blue
//            GradientColor(
//                UIGradientStyle.TopToBottom,
//                frame: CGRectMake(0, 0, ScreenSize.Width, 64),
//                colors: [UIColor(red:0.45, green:0.44, blue:0.87, alpha:1),
//                    UIColor(red:0.53, green:0.52, blue:0.93, alpha:1)])
        
        return true
    }
}

