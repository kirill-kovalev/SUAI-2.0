//
//  AppDelegate.swift
//  AirrouteApp
//
//  Created by Кирилл on 30.07.2020.
//  Copyright © 2020 kirill-kovalev. All rights reserved.
//

import UIKit
import SUAI_API

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: - Main AppDelegate lifecycle
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //
        //testRun()
        DispatchQueue.global(qos: .background).async {
            if SAUserSettings.shared?.group != nil{
                DispatchQueue.main.async {
                    self.startApp()
                }
            }else{
                DispatchQueue.main.async {
                    self.showTutorialPages()
                }
            }
        }

        
        return true
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
