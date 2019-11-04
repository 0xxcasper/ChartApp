//
//  Utility.swift
//

import Foundation

//func delay(delay:Double, complete:()->()) {
//    dispatch_after(
//        dispatch_time(
//            dispatch_time_t(DISPATCH_TIME_NOW),
//            Int64(delay * Double(NSEC_PER_SEC))
//        ),
//        dispatch_get_main_queue(), complete)
//}

// Returns the most recently presented UIViewController (visible)
func getCurrentViewController() -> UIViewController? {
    
    // If the root view is a navigation controller, we can just return the visible ViewController
    if let navigationController = getNavigationController() {
        
        return navigationController.visibleViewController
    }
    
    // Otherwise, we must get the root UIViewController and iterate through presented views
    if let rootController = UIApplication.shared.keyWindow?.rootViewController {
        
        var currentController: UIViewController! = rootController
        
        // Each ViewController keeps track of the view it has presented, so we
        // can move from the head to the tail, which will always be the current view
        while( currentController.presentedViewController != nil ) {
            
            currentController = currentController.presentedViewController
        }
        return currentController
    }
    
    return nil
}

// Returns the navigation controller if it exists
func getNavigationController() -> UINavigationController? {
    
    if let navigationController = UIApplication.shared.keyWindow?.rootViewController  {
        
        return navigationController as? UINavigationController
    }
    return nil
}
