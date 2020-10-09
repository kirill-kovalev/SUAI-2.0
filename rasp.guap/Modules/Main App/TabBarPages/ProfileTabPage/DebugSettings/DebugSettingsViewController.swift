//
//  DebugSettingsViewController.swift
//  rasp.guap
//
//  Created by Кирилл on 04.10.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit
import UserNotifications
import SwiftyVK

class DebugSettingsViewController: ModalViewController <DebugSettingsView> {

	override func viewDidLoad() {
		self.setTitle("DEBUG")
		self.content.textField.text = Logger.log
		self.content.oldimetable.toggle.isOn = AppSettings.isOldTimetableEnabled
		self.content.oldimetable.toggle.addTarget(self, action: #selector(self.setOldTimetable), for: .valueChanged)
		
		
		self.content.goodTB.toggle.isOn = AppSettings.isGoodTabBar
		self.content.goodTB.toggle.addTarget(self, action: #selector(self.setGoodTabBar), for: .valueChanged)
		
		self.content.listNotificationsBtn.setTitle("List  notifications", for: .normal)
		self.content.listNotificationsBtn.addTarget(action: { (_) in
			UNUserNotificationCenter.current().getPendingNotificationRequests { (requests) in
				DispatchQueue.main.async {
					
					
					if requests.isEmpty {
						self.content.textField.text = "no pending notifications "
					}else{
						self.content.textField.text = ""
					}
					for r in requests {
						let trigger = r.trigger as? UNCalendarNotificationTrigger
						self.content.textField.text += "\(r.content.title) at \(trigger?.dateComponents as Any)\n\n"
					}
				}
			}
		}, for: .touchUpInside)
		
		self.content.checkVK.setTitle("VK Autch Check", for: .normal)
		self.content.checkVK.addTarget(action: { (_) in
			Logger.print("VK: start check")
			if VK.needToSetUp {
				Logger.print("VK: needsToSetup")
			}else{
				Logger.print("VK: set up ok")
				Logger.print("VK: session status \(VK.sessions.default.state)")
				VK.API.Users.get([.fields:"photo_100"]).onError { (err) in
					Logger.print("VK: Error - \(err)")
				}.onSuccess { (data) in
					Logger.print("VK: success - \(data)")
				}.send()
			}
		}, for: .touchUpInside)
	}
	@objc private func setOldTimetable(){
		AppSettings.isOldTimetableEnabled = self.content.oldimetable.toggle.isOn
		Logger.print(from: "", "ВСЕ ОК, отчеты отклоню, оно не вылетает, а закрывается")
		//exit(0)
	}
	@objc private func setGoodTabBar(){
		AppSettings.isGoodTabBar = self.content.goodTB.toggle.isOn
		Logger.print(from: "", "ВСЕ ОК, отчеты отклоню, оно не вылетает, а закрывается")
		//exit(0)
	}
}
