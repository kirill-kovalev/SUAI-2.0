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
        print(VK.sessions.default.state)
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
        //print(VK.sessions.default.accessToken?.get())
        if SAUserSettings.fromServer()?.group == nil {
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
        VK.sessions.default.logIn(onSuccess: { _ in
            PocketAPI.shared.setToken(VK.sessions.default.accessToken!.get()!)
        }) { (err) in
            
        }
    }
    
    
    
    
    
    func testRun(){
        guard let user = SASchedule.shared.groups.get(name: "1611") else{
                                                                print("user not found")
                                                                return
                                                            }
        let timetable = SASchedule.shared.get(for: user )
        let dayTimetable = timetable.get(week: .even, day: 0)
        
        let tt = TimetableViewController()
        tt.setTimetable(timetable: dayTimetable)
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = ScheduleTabViewController()
        window?.makeKeyAndVisible()
        
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
