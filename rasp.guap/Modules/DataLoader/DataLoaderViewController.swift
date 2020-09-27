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
			self.loadData()
		}
		self.rootView.reloadButton.addTarget(action: { (_) in
			DispatchQueue.global().async { self.loadData()}
		}, for: .touchUpInside)
	}
	func loadData(){
		DispatchQueue.main.async {
			self.rootView.reloadButton.isHidden = true
		}
		self.setText("Загружаю настройки")
		let settings = SAUserSettings.shared
		
		if let group = settings.group {
			self.setText("Загружаю расписание")
			SASchedule.shared.loadFromCache()
			if SASchedule.shared.groups.count == 0{
				SASchedule.shared.groups.loadFromServer()
			}
			if SASchedule.shared.preps.count == 0{
				SASchedule.shared.preps.loadFromServer()
			}
			if let user = SASchedule.shared.groups.get(name: group ){
				let timetable = SASchedule.shared.get(for: user)
				
				
				// - MARK: УВедомления расписания!!!!!
				if !timetable.setupNotifications(), NotificationManager.shared.isAuth  {
					DispatchQueue.main.async {self.showSnack(status: .err, text: "Не удалось установить уведомления Расписания")}
				}
				
				self.setWatchTimetable(timetable)
			} else {
				DispatchQueue.main.async {self.showSnack(status: .err, text: "Не удалось загрузить расписание")}
			}

			self.setText("Загружаю дедлайны")
			SADeadlines.shared.loadFromCache()
			if SADeadlines.shared.all.isEmpty{
				if !SADeadlines.shared.loadFromServer() {
					DispatchQueue.main.async {self.showSnack(status: .err, text: "Не удалось загрузить дедлайны")}
				}
			}
			// - MARK: УВедомления дедлайнов!!!!!
			if !SADeadlines.shared.setupNotifications(), NotificationManager.shared.isAuth {
				DispatchQueue.main.async {self.showSnack(status: .err, text: "Не удалось установить уведомления Дедлайнов")}
			}
			
			self.setText("Загружаю новости")
			if !SABrief.shared.loadFromServer() {
				DispatchQueue.main.async {self.showSnack(status: .err, text: "Не удалось загрузить сводку")}
			}
			let _ = SANews.shared.loadSourceList()
			self.startApp()
		}else{
			self.setText("Загружаю список групп")
			SASchedule.shared.groups.loadFromServer()
			if SASchedule.shared.groups.count == 0 {
				DispatchQueue.main.async {
					self.showSnack(status: .err, text: "Не удалось загрузить список групп.")
					self.rootView.reloadButton.isHidden = false
				}
			}else{
				self.showTutorialPages()
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
	
	func showSnack(status:PocketSnackView.Status,text:String){
		let snack = PocketSnackView(status: status, text: text)
		let snackBarDiv = PocketDivView(content: snack)
		let snackContainer = PocketScalableContainer(content: snackBarDiv)
		
		self.view.addSubview(snackContainer)
		snackContainer.snp.makeConstraints { (make) in
			make.left.equalToSuperview().offset(10)
			make.right.equalToSuperview().inset(10)
			make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-15)
		}
		snackContainer.addTarget(action: {_ in
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
				self.hideSnack(snackContainer)
			})
		}, for: .touchUpInside)
		
		let offset = self.view.frame.height-snack.frame.origin.y
		snackContainer.transform = .init(translationX: 0, y: offset)
		
		UIView.animate(withDuration: 0.3) { snackContainer.transform = .identity }
		DispatchQueue.main.asyncAfter(deadline: .now() + 3) { self.hideSnack(snackContainer) }
	}
	
	func hideSnack(_ snack:UIView){
		let offset = self.view.frame.height-snack.frame.origin.y
		UIView.animate(withDuration: 0.3, animations: {
			snack.transform = .init(translationX: 0, y: offset)
		}) { (ended) in
			snack.removeFromSuperview()
		}
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
