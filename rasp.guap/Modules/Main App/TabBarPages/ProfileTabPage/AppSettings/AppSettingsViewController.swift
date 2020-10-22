//
//  AppSettingsViewController.swift
//  rasp.guap
//
//  Created by Кирилл on 28.09.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit
import SUAI_API

class AppSettingsViewController: ViewController<AppSettingsView> {
	override func viewDidLoad() {
		super.viewDidLoad()
		self.rootView.deadlineNotifications.toggle.addTarget(self, action: #selector(self.setupDeadlineNotifications), for: .valueChanged)
		self.rootView.timetableNotifications.toggle.addTarget(self, action: #selector(self.setupTimetableNotifications), for: .valueChanged)
		self.rootView.oldTimetable.toggle.addTarget(self, action: #selector(self.setOldTimetable), for: .valueChanged)
		self.rootView.fastLoading.toggle.addTarget(self, action: #selector(self.setFastLoading), for: .valueChanged)
		
		self.rootView.clearCacheBtn.addTarget(action: { (_) in
			let alert = UIAlertController(title: "Сброс кэша", message: "Приложение будет закрыто", preferredStyle: .actionSheet)
			alert.addAction(UIAlertAction(title: "Продолжить", style: .destructive, handler: { (_) in
				AppSettings.clearCache()
				NetworkManager.clearCache()
				exit(0)
			}))
			alert.addAction(UIAlertAction(title: "Отмена", style: .default, handler: { (_) in
				NotificationManager.shared.debugList()
				alert.dismiss(animated: true, completion: nil)
			}))
			self.present(alert, animated: true, completion: nil)
		}, for: .touchUpInside)
	}
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.rootView.timetableNotifications.toggle.isOn = AppSettings.isTimetableNotificationsEnabled
		self.rootView.deadlineNotifications.toggle.isOn = AppSettings.isDeadlineNotificationsEnabled
		self.rootView.oldTimetable.toggle.isOn = AppSettings.isOldTimetableEnabled
		self.rootView.fastLoading.toggle.isOn = AppSettings.isFastLoadingEnabled
	}
	
	@objc private func setFastLoading() {
		let alert = UIAlertController(title: "Включить?", message: "Быстрая загрузка может привести к неактуальности данных, используйте эту функцию с осторожностью!", preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: { (_) in alert.dismiss(animated: true, completion: nil) }))
		alert.addAction(UIAlertAction(title: "Включить", style: .default, handler: { (_) in
			AppSettings.isFastLoadingEnabled = self.rootView.deadlineNotifications.toggle.isOn
		}))
		
		self.present(alert, animated: true, completion: nil)
	}
	
	@objc private func setupDeadlineNotifications() {
		AppSettings.isDeadlineNotificationsEnabled = self.rootView.deadlineNotifications.toggle.isOn
		
		if self.rootView.deadlineNotifications.toggle.isOn {
			if SADeadlines.shared.setupNotifications() {
				if NotificationManager.shared.isAuth {
					MainTabBarController.Snack(status: .ok, text: "Оповещения о дедлайнах включены")
				} else {
					MainTabBarController.Snack(status: .err, text: "Нет доступа, разрешите уведомления для приложения в настройках iOS")
					self.rootView.deadlineNotifications.toggle.isOn = false
				}
			} else {
				MainTabBarController.Snack(status: .err, text: "Не удалось включить уведомления")
				self.rootView.deadlineNotifications.toggle.isOn = false
			}
		} else {
			MainTabBarController.Snack(status: .ok, text: "Оповещения о дедлайнах выключены")
			NotificationManager.shared.clearDeadlineNotifications()
		}
	}
	
	@objc private func setupTimetableNotifications() {
		AppSettings.isTimetableNotificationsEnabled = self.rootView.timetableNotifications.toggle.isOn
		
		if self.rootView.timetableNotifications.toggle.isOn {
			if let group = SAUserSettings.shared.group,
			let user = SASchedule.shared.groups.get(name: group),
			SASchedule.shared.get(for: user).setupNotifications() {
				if NotificationManager.shared.isAuth {
					MainTabBarController.Snack(status: .ok, text: "Оповещения о занятиях включены")
				} else {
					MainTabBarController.Snack(status: .err, text: "Нет доступа, разрешите уведомления для приложения в настройках iOS")
					self.rootView.timetableNotifications.toggle.isOn = false
				}
				
            } else {
				MainTabBarController.Snack(status: .err, text: "Не удалось включить уведомления")
				self.rootView.timetableNotifications.toggle.isOn = false
			}
			
		} else {
			MainTabBarController.Snack(status: .ok, text: "Оповещения о занятиях выключены")
			NotificationManager.shared.clearLessonNotifications()
		}
	}
	
	@objc private func setOldTimetable() {
		AppSettings.isOldTimetableEnabled = self.rootView.oldTimetable.toggle.isOn
		MainTabBarController.Snack(status: .ok, text: "Изменения станут активны при следующем запуске приложения")
	}
}
