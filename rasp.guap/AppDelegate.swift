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
    
    private let vkDelegate  = (UINib(nibName: "VkLogin", bundle: nil).instantiate(withOwner: nil, options: nil).first as! VKLoginPageViewController)
    
	func setupWatchConnetivity(){
		if WCSession.isSupported(){
			let session = WCSession.default
			session.delegate = self
			session.activate()
		}
	}
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		
        VK.setUp(appId: "7578765", delegate: vkDelegate)
		VK.sessions.default.config.language = .ru
        if VK.sessions.default.state != .authorized {
            self.PresentVKLoginPage()
        }else{
            self.LoggedInVK()
			setupWatchConnetivity()
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
		print(VK.sessions.default.accessToken?.get() ?? "failed to get token")
		window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = DataLoaderViewController()
        window?.makeKeyAndVisible()
    }
    
    
    
    func PresentVKLoginPage(){
        VK.release()
        window = UIWindow(frame: UIScreen.main.bounds)
		window?.rootViewController = self.vkDelegate
        window?.makeKeyAndVisible()
        

    }
    

	func applicationDidBecomeActive(_ application: UIApplication) {
//		if !VK.needToSetUp {
//			SATracker.track("start")
//		}
//		if !NotificationManager.shared.isAuth {
//			MainTabBarController.Snack(status: .err, text: "Уведомления недоступны")
//		}
	}
	func applicationWillResignActive(_ application: UIApplication) {
//		if !VK.needToSetUp {
//			SATracker.track("hide")
//		}
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
	func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
		DispatchQueue.global().async {
			let settings = SAUserSettings.shared
			let group = settings.group
			
			guard let user = SASchedule.shared.groups.get(name: group! ) else {return}
			let _ = SASchedule.shared.load(for: user)
			let timetable = SASchedule.shared.get(for: user)
			self.setWatchTimetable(timetable)
		}
	}
	func setWatchTimetable(_ tt:SATimetable){
		print("Setting Watch TT")
		if WCSession.isSupported(){
			if WCSession.default.activationState == .activated {
				let today = Calendar.convertToRU(Calendar.current.component(.weekday, from: Date()))
				let curWeek = SASchedule.shared.settings?.week ?? .odd
				let timetable = tt.get(week: curWeek, day: today).map { lesson -> [String] in
					let preps = lesson.prepods.map{$0.shortName}.joined(separator: ";\n")
					let tags = lesson.tags.joined(separator: "; ")
					return [lesson.type.rawValue,lesson.name,"\(lesson.start) – \(lesson.end)",preps,tags]
				}
				
				do{
					let encoded = try JSONEncoder().encode(timetable)
					try WCSession.default.updateApplicationContext(["timetable":encoded])
				}catch{print(error)}
			}
		}
		print("End of Setting Watch TT")
	}
	
}
