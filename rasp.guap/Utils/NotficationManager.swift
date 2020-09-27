//
//  NotficationManager.swift
//  rasp.guap
//
//  Created by Кирилл on 27.09.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import Foundation
import UserNotifications
import SUAI_API

class NotficationManager{
	static let shared = NotficationManager()
	
	private let center = UNUserNotificationCenter.current()
	
	
	init(){
		center.requestAuthorization(options: []) { (didAllow, err) in
			print("\(#function): \(err)")
			print("\(#function): didAllow = \(didAllow)")
		}
	}
	
	func setNotification(){
		
		
//		let notification =
	}
	
	func createTrigger(weekday:Int,hour:Int,minutes:Int)->UNNotificationTrigger{
		let dateComponents = DateComponents(calendar: .current, timeZone: .current,hour: hour, minute: minutes, second: 0, weekday: Calendar.convertToUS(weekday))
		let triggerDate = Calendar.current.date(from: dateComponents) ?? Date()
		let dateMatching = Calendar.current.dateComponents([.weekday,.hour,.minute], from: triggerDate)
		
		let trigger = UNCalendarNotificationTrigger(dateMatching: dateMatching, repeats: true)
		
		return trigger
	}
}
