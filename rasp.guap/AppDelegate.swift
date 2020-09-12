//
//  AppDelegate.swift
//  AirrouteApp
//
//  Created by Кирилл on 30.07.2020.
//  Copyright © 2020 kirill-kovalev. All rights reserved.
//

import UIKit
import SUAI_API
import SwiftyVK
import WatchConnectivity

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: - Main AppDelegate lifecycle
    
    var window: UIWindow?
    
    private let vkDelegate  = VKDelegate()
    
	func setupWatchConnetivity(){
		if WCSession.isSupported(){
			let session = WCSession.default
			session.delegate = self
			session.activate()
		}
	}
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
         setupWatchConnetivity()
        VK.setUp(appId: "7578765", delegate: vkDelegate)
		VK.sessions.default.config.language = .ru
        if VK.sessions.default.state != .authorized {
            self.PresentVKLoginPage()
        }else{
            self.LoggedInVK()
        }
        
        return true
    }
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let app = options[.sourceApplication] as? String
        VK.handle(url: url, sourceApplication: app )
        return true
    }
    
    
    func LoggedInVK(){
        PocketAPI.shared.setToken(VK.sessions.default.accessToken?.get() ?? "")
		window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = DataLoaderViewController()
        window?.makeKeyAndVisible()
    }
    
    
    
    func PresentVKLoginPage(){
        VK.release()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UINib(nibName: "VkLogin", bundle: nil).instantiate(withOwner: nil, options: nil).first as! VKLoginPageViewController
        window?.makeKeyAndVisible()
        

    }
    
    
    
  
   
    
}


extension UIApplication{
    var appDelegate: AppDelegate{
        return self.delegate as! AppDelegate
    }
}
extension AppDelegate:WCSessionDelegate{
	func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
		print(#function)
		if let error = error {
            fatalError("Can't activate session with error: \(error.localizedDescription)")
        }
        print("WC Session activated with state: \(activationState.rawValue)")
	}
	
	func sessionDidBecomeInactive(_ session: WCSession) {
		print(#function)
	}
	
	func sessionDidDeactivate(_ session: WCSession) {
		print(#function)
	}
	
}
