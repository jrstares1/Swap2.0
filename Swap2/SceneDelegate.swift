//
//  SceneDelegate.swift
//  Swap2
//
//  Created by Justin Stares on 10/14/20.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
        
        
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.

    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>){
        // Determine who sent the URL.
        

        guard let context = URLContexts.first else { return }
        
        guard let components = NSURLComponents(url: context.url.absoluteURL, resolvingAgainstBaseURL: true),
                let albumPath = components.path,
                let host = components.host,
                let params = components.queryItems else {
                    print("Invalid URL or album path missing")
                    return
            }

        
        
        //code for Twitter
        if let oauth_verifier = params.first(where: { $0.name == "oauth_verifier" })?.value {
            print("Oauth Verifier: \(oauth_verifier)")
//            print("Oauth Token: \(Otoken)")
//
            print(GlobalVar.oauthRequestToken)
            print(GlobalVar.oauthRequestTokenSecret)

            
            let url = URL(string: "https://us-central1-swap-2b365.cloudfunctions.net/api/twitter/\(GlobalVar.oauthRequestToken)/\(GlobalVar.oauthRequestTokenSecret)/\(oauth_verifier)")
            print("url below")
            print(url)
            guard let requestUrl = url else { fatalError() }

            // Create URL Request
            var request = URLRequest(url: requestUrl)

            // Specify HTTP Method to use
            request.httpMethod = "POST"
            // Request Header
//            print(GlobalVar.IdToken)
            request.setValue("Bearer " + GlobalVar.IdToken, forHTTPHeaderField: "Authorization")

            // Send HTTP Request
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in

            // Check if Error took place
            if let error = error {
                print("Twitter Error took place \(error)")
                    return
            }

            // Read HTTP Response Status code
            if let response = response as? HTTPURLResponse {
                print("Twitter Response HTTP Status code: \(response.statusCode)")
            }

            // TODO: do we need to fix this?????
            //ADD Later if we get a 403 error stop.

            // Convert HTTP Response Data to a simple String
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                print("Twitter Response data string:\n \(dataString)")
            }

            }
            task.resume()
        
        
            
        }

        //code for Github/Spotify
        if let code = params.first(where: { $0.name == "code" })?.value {
//            print("Code: \(code)")
        
            // Send token to your backend via HTTPS
//            print(host)
            let url = URL(string: "https://us-central1-swap-2b365.cloudfunctions.net/api/" + host + "/" + code)
            guard let requestUrl = url else { fatalError() }

            // Create URL Request
            var request = URLRequest(url: requestUrl)

            // Specify HTTP Method to use
            request.httpMethod = "POST"
            // Request Header
            print(GlobalVar.IdToken)
            request.setValue("Bearer " + GlobalVar.IdToken, forHTTPHeaderField: "Authorization")

            // Send HTTP Request
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                    
            // Check if Error took place
            if let error = error {
                print("Error took place \(error)")
                    return
            }
                    
            // Read HTTP Response Status code
            if let response = response as? HTTPURLResponse {
                print("Response HTTP Status code: \(response.statusCode)")
            }
            
            // TODO: do we need to fix this?????
            //ADD Later if we get a 403 error stop.
            
            // Convert HTTP Response Data to a simple String
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                print("Response data string:\n \(dataString)")
            }
                    
            }
            task.resume()

                
        }
        
        
        
//        UserDefaults.standard.set(code, forKey: "Code")  //String

        //this way of transition reloads the view controller. I send it to accountVC
//        let storyboard: UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
//        let rootVC: UIViewController = storyboard.instantiateViewController(withIdentifier: "AccountVC") as UIViewController
//        
//        let rootNC = UINavigationController(rootViewController: rootVC)
//        self.window?.rootViewController = rootNC
//        self.window?.makeKeyAndVisible()

//        this way of transistion does not reload the view controller
//        let storyboard: UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
//        let initViewController: UIViewController = storyboard.instantiateViewController(withIdentifier: "HomeVC") as UIViewController
//        let rootViewController = self.window!.rootViewController as! UINavigationController;
//        rootViewController.pushViewController(initViewController, animated: true);
//
    }
   

        
            



}

