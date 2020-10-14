//
//  AppDelegate.swift
//  ProjectMap
//
//  Created by Михаил Зайцев on 25/09/2020.
//  Copyright © 2020 Михаил Зайцев. All rights reserved.
//

import UIKit
import GoogleMaps
//import GooglePlaces

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    //var timer: Timer?
    //var beginBackgroundTask: UIBackgroundTaskIdentifier?
    //var timerCount = 10

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        GMSServices.provideAPIKey("AIzaSyBYO_jJYjF6EnHl8hN_QsSKxBjcwqtUI3c")
        //GMSPlacesClient.provideAPIKey("AIzaSyBYO_jJYjF6EnHl8hN_QsSKxBjcwqtUI3c")
        
        
        /*beginBackgroundTask = UIApplication.shared.beginBackgroundTask(expirationHandler: {
            [weak self] in
            guard let strongSelf = self else {return}
            
            UIApplication.shared.endBackgroundTask(strongSelf.beginBackgroundTask!)
            strongSelf.beginBackgroundTask = UIBackgroundTaskIdentifier.invalid
        })
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {
            [weak self] (_) in
            //print(Date())
            if self?.timerCount == 0 {
                self?.timer?.invalidate()
                UIApplication.shared.endBackgroundTask((self?.beginBackgroundTask!)!)
                self?.beginBackgroundTask = UIBackgroundTaskIdentifier.invalid
            } else {
                self?.timerCount -= 1
            }
            
        })*/
        
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

