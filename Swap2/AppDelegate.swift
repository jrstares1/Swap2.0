//
//  AppDelegate.swift
//  Swap2
//
//  Created by Justin Stares on 10/14/20.
//  Gillian helped too :)
//

import UIKit
import Firebase
import BackgroundTasks

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    let userDefault = UserDefaults.standard
    let launchedBefore = UserDefaults.standard.bool(forKey: "usersignedin")
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        registerBackgroundTasks()
        FirebaseApp.configure()
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        submitBackgroundTasks()
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
        let id = "com.example.fooBackgroundAppRefreshIdentifier"
        //let backgroundProcessingTaskSchedulerIdentifier = "com.example.fooBackgroundProcessingIdentifier"

        BGTaskScheduler.shared.register(forTaskWithIdentifier: id, using: nil) { (task) in
           print("BackgroundAppRefreshTaskScheduler is executed NOW!")
           print("Background time remaining: \(UIApplication.shared.backgroundTimeRemaining)s")
           task.expirationHandler = {
             task.setTaskCompleted(success: false)
           }
          // Do some data fetching and call setTaskCompleted(success:) asap!
           print("santa is real")
          // homePageViewController.swapListener()
           let isFetchingSuccess = true
           task.setTaskCompleted(success: isFetchingSuccess)
         }
    }
    
    func submitBackgroundTasks() {
        // Declared at the "Permitted background task scheduler identifiers" in info.plist
        let id = "com.example.fooBackgroundAppRefreshIdentifier"
        let timeDelay = 60.0
        do {
          let request = BGAppRefreshTaskRequest(identifier: id)
          request.earliestBeginDate = Date(timeIntervalSinceNow: timeDelay)
          try BGTaskScheduler.shared.submit(request)
          print("Submitted task request")
        } catch {
          print("Failed to submit BGTask")
        }
      }
    
    


}


