//
//  AppDelegate.swift
//  AirrouteApp
//
//  Created by Кирилл on 30.07.2020.
//  Copyright © 2020 kirill-kovalev. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: - Main AppDelegate lifecycle
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //
        //startApp()
        //showTutorialPages()
        testRun()
        return true
    }
    func testRun(){
        guard let user = Schedule.shared.groups.get(name: "1611") else{
                                                                print("user not found")
                                                                return
                                                            }
        let timetable = Schedule.shared.get(for: user )
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
    
    
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "rasp__guap")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}


extension UIApplication{
    var appDelegate: AppDelegate{
        return self.delegate as! AppDelegate
    }
}
