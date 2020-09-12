//
//  DataLoaderViewController.swift
//  rasp.guap
//
//  Created by Кирилл on 09.09.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit
import SUAI_API
import SwiftyVK
import WatchConnectivity

class DataLoaderViewController:ViewController<DataLoaderView>{
	override func viewDidLoad() {
		super.viewDidLoad()
		
		DispatchQueue.global().async {

			self.setText("Загружаю настройки")
			let settings = SAUserSettings.shared
			if settings == nil {
				self.setText("Не удалось получить настройки")
			}else{
				let group = settings?.group
				if group  == nil {
					self.setText("Загружаю список групп")
					SASchedule.shared.groups.loadFromServer()
					self.showTutorialPages()
				}else{
					guard let user = SASchedule.shared.groups.get(name: group! ) else {
						self.setText("Не удалось получить расписание!")
						return
					}
					self.setText("Загружаю расписание")
					let _ = SASchedule.shared.load(for: user)
					let timetable = SASchedule.shared.get(for: user)
					self.setWatchTimetable(timetable)
					self.setText("Загружаю дедлайны")
					SADeadlines.shared.loadFromServer()
					self.setText("Загружаю новости")
					SABrief.shared.loadFromServer()
					SANews.shared.loadSourceList()
					self.startApp()
				}
			}
		}
	}
	
	func setWatchTimetable(_ tt:SATimetable){
		print("Setting Watch TT")
		if WCSession.isSupported(){
			if WCSession.default.activationState == .activated {
				let today = Calendar.convertToRU(Calendar.current.component(.weekday, from: Date()))
				let curWeek = SASchedule.shared.settings?.week ?? .odd
				let timetable = tt.get(week: curWeek, day: today).map { lesson -> [String] in
					let preps = lesson.prepods.map{$0.Name}.joined(separator: ",\n")
					return [lesson.type.rawValue,lesson.name,"\(lesson.start) – \(lesson.end)",preps]
				}
				
				do{
					let encoded = try JSONEncoder().encode(timetable)
					try WCSession.default.updateApplicationContext(["timetable":encoded])
				}catch{print(error)}
			}
		}
		print("End of Setting Watch TT")
	}
	func setText(_ text:String){
		DispatchQueue.main.async {
			self.rootView.label.text = text
		}
	}
	func showTutorialPages(){
		DispatchQueue.main.async {
			let vc = TutorialScreenViewController()
			vc.modalTransitionStyle = .flipHorizontal
			vc.modalPresentationStyle = . fullScreen
			self.present(vc, animated: true, completion: nil)
		}
	}
	func startApp(){
		DispatchQueue.main.async {
			let vc = MainTabBarController()
			vc.modalTransitionStyle = .flipHorizontal
			vc.modalPresentationStyle = . fullScreen
			self.present(vc, animated: true, completion: nil)
		}
	}
}
