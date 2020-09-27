//
//  NotificationManager.swift
//  rasp.guap
//
//  Created by Кирилл on 27.09.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import Foundation
import UserNotifications
import SUAI_API

class NotificationManager{
	static let shared = NotificationManager()
	
	public let center = UNUserNotificationCenter.current()
	
	public var isAuth:Bool {
		var success = false
		let sem = DispatchSemaphore(value: 0)
		self.center.getNotificationSettings { (settings) in
			success =  (settings.authorizationStatus == .authorized) //|| (settings.authorizationStatus == .notDetermined)
		}
		let _ = sem.wait(timeout: .distantFuture)
		return success
	}
	public func auth() -> Bool{
		var success = false
		let sem = DispatchSemaphore(value: 0)
		center.requestAuthorization(options: [.alert,.sound]) { (didAllow, err) in
			print("\(#function): \(String(describing: err))")
			print("\(#function): didAllow = \(didAllow)")
			success = didAllow
			sem.signal()
		}
		let _ = sem.wait(timeout: .distantFuture)
		return success
	}
	public func add(request:UNNotificationRequest) -> Bool{
		var success = false
		let sem = DispatchSemaphore(value: 0)
		center.add(request) { (err) in
			if err == nil {
				success = true
			}else{
				print(err as Any)
			}
			sem.signal()
		}
		let _ = sem.wait(timeout: .distantFuture)
		return success
	}
	
	public func clear(){
		center.removeAllPendingNotificationRequests()
		center.removeAllDeliveredNotifications()
	}
	
	public func clearDeadlineNotifications(){
		center.getPendingNotificationRequests { (requests) in
			let lessonRequests = requests.filter { $0.identifier.contains("deadline") }
			let identifiers = lessonRequests.map {$0.identifier}
			self.center.removePendingNotificationRequests(withIdentifiers: identifiers)
			for id in identifiers {
				print("removed notification with id: \(id)")
			}
		}
	}
	public func clearLessonNotifications(){
		center.getPendingNotificationRequests { (requests) in
			let lessonRequests = requests.filter { $0.identifier.contains("lesson") }
			let identifiers = lessonRequests.map {$0.identifier}
			self.center.removePendingNotificationRequests(withIdentifiers: identifiers)
			for id in identifiers {
				print("removed notification with id: \(id)")
			}
		}
	}
	
	public func createNotification(for:SALesson)->UNNotificationRequest{
		let lesson = `for`
		let offset = 5
		let content = createContent(title: lesson.name, body: "Начало через \(offset) минут", badge: 0)
		let trigger = createTrigger(weekday: lesson.day, hour: lesson.startTime.hour!, minute: lesson.startTime.minute!)
		let request = UNNotificationRequest(identifier: "lesson_\(lesson)", content: content, trigger: trigger)
		return request
	}
	public func createNotification(for:SADeadline)->UNNotificationRequest{
		let deadline = `for`
		let content = createContent(title: "Пора приступать за \(deadline.deadline_name ?? "")", body: "Дедлайн наступил", badge: 1)
		let trigger = createTrigger(date: deadline.end ?? Date())
		let request = UNNotificationRequest(identifier: "deadline_\(deadline)", content: content, trigger: trigger)
		return request
	}
	
	private func createContent(title:String,body:String,badge:Int) -> UNMutableNotificationContent{
		let notification = UNMutableNotificationContent()
		notification.title = title
		notification.body = body
		notification.sound = .default
		notification.badge = NSNumber(value: badge)
		return notification
	}
	
	private func createTrigger(weekday:Int,hour:Int,minute:Int,offset:Int = 0)->UNNotificationTrigger{
		let hours = (minute-offset) < 0 ? hour-1 : hour
		let hour = hours > 0 ? hours : 23
		
		let minute = (minute-offset) < 0 ? (60-offset) : minute-offset
		

		let dateComponents = DateComponents(hour: hour, minute: minute,weekday: Calendar.convertToUS(weekday))
		let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
		
		return trigger
	}
	
	private func createTrigger(date:Date)->UNNotificationTrigger{
		
		let dateComponents = Calendar.current.dateComponents([.year,.month,.day], from: date)
		let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
		
		return trigger
	}
	
}

extension SATimetable{
	func setupNotifications() -> Bool{
		var success = true
		NotificationManager.shared.clearLessonNotifications()
		for lesson in self.get(week: .current){
			let request = NotificationManager.shared.createNotification(for: lesson)
			if !NotificationManager.shared.add(request: request) {success = false} else {print("created notif for timetable: \((request.trigger as? UNCalendarNotificationTrigger)?.nextTriggerDate())")}
			
		}
		return success
	}
}
extension SADeadlines{
	func setupNotifications() -> Bool{
		var success = true
		NotificationManager.shared.clearLessonNotifications()
		for deadline in self.open {
			let request = NotificationManager.shared.createNotification(for: deadline)
			if !NotificationManager.shared.add(request: request) {success = false} else { print("created notif for deadlines: \((request.trigger as? UNCalendarNotificationTrigger)?.nextTriggerDate())") }
		}
		return success
	}
}
// - MARK: УВедомления расписания!!!!!
