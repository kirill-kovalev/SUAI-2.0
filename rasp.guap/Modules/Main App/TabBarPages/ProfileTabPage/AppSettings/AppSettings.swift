//
//  AppSettings.swift
//  rasp.guap
//
//  Created by Кирилл on 28.09.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import Foundation

struct AppSettings {
	static var isDeadlineNotificationsEnabled:Bool{
		get{
			let get = UserDefaults.standard.bool(forKey: "deadlineNotifications")
			Logger.print(from: #function, "isDeadlineNotificationsEnabled get \(get)")
			return get
		}
		set{
			UserDefaults.standard.synchronize()
			UserDefaults.standard.set(newValue, forKey: "deadlineNotifications")
			Logger.print(from: #function, "isDeadlineNotificationsEnabled set \(newValue)")
		}
	}
	
	static var isTimetableNotificationsEnabled:Bool{
		get{
			UserDefaults.standard.synchronize()
			let get = UserDefaults.standard.bool(forKey: "timetableNotifications")
			Logger.print(from: #function, "isTimetableNotificationsEnabled get \(get)")
			return get
		}
		set{
			UserDefaults.standard.synchronize()
			UserDefaults.standard.set(newValue, forKey: "timetableNotifications")
			Logger.print(from: #function, "isTimetableNotificationsEnabled set \(newValue)")
		}
	}
	
	static var isOldTimetableEnabled:Bool{
		get{
			UserDefaults.standard.synchronize()
			let get = UserDefaults.standard.bool(forKey: "oldTimetable")
			Logger.print(from: #function, "isOldTimetableEnabled get \(get)")
			return get
		}
		set{
			UserDefaults.standard.synchronize()
			UserDefaults.standard.set(newValue, forKey: "oldTimetable")
			Logger.print(from: #function, "isOldTimetableEnabled set \(newValue)")
		}
	}
	
	static func clearCache(){
		NotificationManager.shared.clear()
		for (key,_) in UserDefaults.standard.dictionaryRepresentation() {
			UserDefaults.standard.removeObject(forKey: key)
		}
		let domain = Bundle.main.bundleIdentifier ?? ""
		UserDefaults.standard.removePersistentDomain(forName: domain)
		
		UserDefaults.standard.synchronize()
		
	}
	
}
