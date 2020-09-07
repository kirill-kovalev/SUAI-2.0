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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: - Main AppDelegate lifecycle
    
    var window: UIWindow?
    
    private let vkDelegate  = VKDelegate()
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
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
        let settings = SAUserSettings.shared
        let group = settings?.group
        if group  == nil {
            self.firstRun()
        }else{
            self.defaultRun()
        }
    }
    
    func firstRun(){
        showTutorialPages()
    }
    func defaultRun(){
        startApp()
    }
    
    func PresentVKLoginPage(){
        VK.release()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UINib(nibName: "VkLogin", bundle: nil).instantiate(withOwner: nil, options: nil).first as! VKLoginPageViewController
        window?.makeKeyAndVisible()
        

    }
    
    
    
    
    
    func testRun(){
               
    }
    
    func showTutorialPages(){
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = TutorialScreenViewController()
        window?.makeKeyAndVisible()
    }
    func startApp(){
        window = UIWindow(frame: UIScreen.main.bounds)
        let tabBar = MainTabBarController()
        window?.rootViewController = tabBar
        window?.makeKeyAndVisible()
    }
    
}


extension UIApplication{
    var appDelegate: AppDelegate{
        return self.delegate as! AppDelegate
    }
}
