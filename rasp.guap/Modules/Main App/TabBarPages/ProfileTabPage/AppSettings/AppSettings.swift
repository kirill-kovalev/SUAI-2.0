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
			UserDefaults.standard.bool(forKey: "deadlineNotifications")
		}
		set{
			UserDefaults.standard.set(newValue, forKey: "deadlineNotifications")
			UserDefaults.standard.synchronize()
		}
	}
	
	static var isTimetableNotificationsEnabled:Bool{
		get{
			UserDefaults.standard.bool(forKey: "timetableNotifications")
		}
		set{
			UserDefaults.standard.set(newValue, forKey: "timetableNotifications")
			UserDefaults.standard.synchronize()
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
