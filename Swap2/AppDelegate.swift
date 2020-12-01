//
//  AppDelegate.swift
//  Swap2
//
//  Created by Justin Stares on 10/14/20.
//  Gillian helped too :)
//

import UIKit
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    let userDefault = UserDefaults.standard
    let launchedBefore = UserDefaults.standard.bool(forKey: "usersignedin")
    
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        registerBackgroundTasks()
        UIApplication.shared.setMinimumBackgroundFetchInterval(
          UIApplication.backgroundFetchIntervalMinimum)
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
    
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        print("hey" + url.absoluteString)
        return true
    }
    

    
    func registerBackgroundTasks(){
        let backgroundAppRefreshTaskSchedulerIdentifier = "BackgroundAppRefreshID"
        let backgroundProcessingTaskSchedulerIdentifier = "BGProcessingTaskRequest"

        // Use the identifier which represents your needs
        //GBTTaskS
        //BGTaskS
//        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.example.apple-samplecode.ColorFeed.refresh", using: nil) { task in
//             self.handleAppRefresh(task: task as! BGAppRefreshTask)
//        }
//        BGTaskScheduler.shared.register(forTaskWithIdentifier: backgroundAppRefreshTaskSchedulerIdentifier, using: nil) { (task) in
//           print("BackgroundAppRefreshTaskScheduler is executed NOW!")
//           print("Background time remaining: \(UIApplication.shared.backgroundTimeRemaining)s")
//           task.expirationHandler = {
//             task.setTaskCompleted(success: false)
//           }
//
//           // Do some data fetching and call setTaskCompleted(success:) asap!
//           let isFetchingSuccess = true
//           task.setTaskCompleted(success: isFetchingSuccess)
//         }
//    }
    }


}


