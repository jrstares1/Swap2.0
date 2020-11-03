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
    
//    func application(_ application: UIApplication,
//                     open url: URL,
//                     options: [UIApplication.OpenURLOptionsKey : Any] = [:] ) -> Bool {
//
//        print ("here1")
//        // Determine who sent the URL.
//        let sendingAppID = options[.sourceApplication]
//        print("source application = \(sendingAppID ?? "Unknown")")
//
//        // Process the URL.
//        guard let components = NSURLComponents(url: url, resolvingAgainstBaseURL: true),
//            let albumPath = components.path,
//            let params = components.queryItems else {
//                print("Invalid URL or album path missing")
//                return false
//        }
//
//        if let photoIndex = params.first(where: { $0.name == "index" })?.value {
//            print("albumPath = \(albumPath)")
//            print("photoIndex = \(photoIndex)")
//            return true
//        } else {
//            print("Photo index missing")
//            return false
//        }
//    }
    
    



}


