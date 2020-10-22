//
//  FeedBriefInfoViewController.swift
//  rasp.guap
//
//  Created by Кирилл on 31.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit
import SUAI_API
import SwiftyVK
import SafariServices

class FeedBriefInfoViewController: UIViewController {
	var rootView: FeedBriefInfoView {self.view as! FeedBriefInfoView}
	override func loadView() {
		self.view = FeedBriefInfoView()
	}
	
	var lastUpdate = Date()
	var isFirstAppear = true
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		if isFirstAppear {
			self.rootView.indicator.startAnimating()
			loadPage()
			isFirstAppear = false
			return
		}
		if lastUpdate.addingTimeInterval(60) < Date() {
			self.updatePage()
		}
	}
	
	private func openGroupInVKApp() {
		UIApplication.shared.open(URL(string: "vk://vk.com/pocketapp")!, options: [:]) { (success) in
			if success { self.updatePage() } else { UIApplication.shared.open(URL(string: "https://vk.com/pocketapp")!, options: [:]) { (_) in self.updatePage() } }
		}
		
	}
	
	func buildBanner() -> UIView {
		let view = PocketBannerView(title: "Вступай в группу!", subtitle: "Узнай о новинках первым!", image: Asset.AppImages.Banners.subscribeBanner.image)
		let div = PocketDivView(content: view)
		view.setButton(title: "Вступить") { btn in
			if let btn = btn as? PocketLongActionButton {
				let alert = UIAlertController(title: "Подписаться?", message: nil, preferredStyle: .alert)
				alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: {_ in alert.dismiss(animated: true, completion: nil)}))
				alert.addAction(UIAlertAction(title: "Да", style: .default, handler: { (_) in
					btn.disable()
					if !VK.needToSetUp {
						VK.API.Groups.join([.groupId: "\(184800526)"]).onSuccess({ (_) in
							DispatchQueue.main.async {
								self.rootView.stack.arrangedSubviews.first?.removeFromSuperview()
								self.rootView.stack.arrangedSubviews.first?.removeFromSuperview()
								self.updatePage()
							}
						}).onError { (_) in
							self.openGroupInVKApp()
						}.send()
					} else {
					}
					
				}))
				self.present(alert, animated: true, completion: nil)
			}
			
		}
		return div
	}
	
	func loadPage() {
		DispatchQueue.global().async {
			if !SAUserSettings.shared.reload() {MainTabBarController.Snack(status: .err, text: "Не удалось получить имя пользователя")}
			if let name = SAUserSettings.shared.vkFirstName {DispatchQueue.main.async {
				self.rootView.addBlock(title: "Добро пожаловать, \(name)")
				}} else {DispatchQueue.main.async {
				self.rootView.addBlock(title: "Добро пожаловать!")
				}}
			
			if SABrief.shared.loadFromServer() {
				if !SABrief.shared.isSub {DispatchQueue.main.async {
					self.rootView.addBlock(view: self.buildBanner())
					self.rootView.addBlock(title: "Погода на сегодня" )
					}}
				DispatchQueue.main.async { self.addWeatherAndRockets() }
			} else {
				MainTabBarController.Snack(status: .err, text: "Не удалось загрузить сводку")
			}
			
			Logger.print(from: #function, "Brief: get tt")
			
			if let group = SAUserSettings.shared.group,
				let user = SASchedule.shared.groups.get(name: group ),
				!SASchedule.shared.get(for: user).isEmpty {
				let timetable = SASchedule.shared.get(for: user)
				let nearestDay = self.getNearestDay(for: timetable)
				
				self.lessons = timetable.get(week: .current, day: nearestDay)
				self.day = nearestDay
				Logger.print("NEAREST DAY: \(nearestDay)")
				DispatchQueue.main.async { self.addSchedule(timetable: self.lessons, day: self.day) }
			} else {
				Logger.print(from: #function, "Brief: err get tt")
				MainTabBarController.Snack(status: .err, text: "Не удалось загрузить расписание")
			}
			Logger.print(from: #function, "Brief: end  get tt")
			
			Logger.print(from: #function, "Brief: load deadlines")
			if SADeadlines.shared.loadFromServer() {
				Logger.print(from: #function, "Brief: add deadlines")
				DispatchQueue.main.async { self.addDeadlines() }
				Logger.print(from: #function, "Brief: end deadlines")
			} else {
				MainTabBarController.Snack(status: .err, text: "Не удалось загрузить дедлайны")
			}
			Logger.print(from: #function, "Brief: end load deadlines")
			
			if !SABrief.shared.events.isEmpty {
				DispatchQueue.main.async { self.addEvents() }
			}
			if !SABrief.shared.news.isEmpty {
				DispatchQueue.main.async { self.addNews() }
			}
			
			DispatchQueue.main.async {self.rootView.indicator.stopAnimating()}
		}
	}
	
	func updatePage() {
		DispatchQueue.global().async {
			_ = SAUserSettings.shared.reload()
			_ = SABrief.shared.loadFromServer()
			_ = SADeadlines.shared.loadFromServer()
			
			DispatchQueue.main.async {
				for v in self.rootView.stack.arrangedSubviews { v.removeFromSuperview() }
				if let name = SAUserSettings.shared.vkFirstName {self.rootView.addBlock(title: "Добро пожаловать, \(name)")}
				if !SABrief.shared.isSub {
					self.rootView.addBlock(view: self.buildBanner())
					self.rootView.addBlock(title: "Погода на сегодня" )
				}
				self.addWeatherAndRockets()
				self.addSchedule(timetable: self.lessons, day: self.day)
				self.addDeadlines()
				
				if !SABrief.shared.events.isEmpty {
					self.addEvents()
				}
				if !SABrief.shared.news.isEmpty {
					self.addNews()
				}
				
				self.lastUpdate = Date()
				
			}
			
		}
	}
	
	// MARK: - Weather
	func addWeatherAndRockets() {
		let temp = SABrief.shared.weather.temp
		let icon = SABrief.shared.weather.id
		let conditions = SABrief.shared.weather.conditions
		let rockets = SABrief.shared.rockets.count
		
		let stack = UIStackView(frame: .zero)
		stack.axis = .horizontal
		stack.alignment = .fill
		stack.distribution = .fillEqually
		stack.spacing = 10
		self.rootView.addBlock(title: nil, view: stack )
		stack.snp.makeConstraints {$0.left.right.equalToSuperview()}
		
		stack.addArrangedSubview(PocketDivView(content: BriefHalfScreenView(title: "\(temp>0 ? "+" : "")\(Int(temp))°", subtitle: conditions,
																			image: self.getWeatherImage(id: icon).0,
																			color: self.getWeatherImage(id: icon).1)))
		
		let rocketsView = BriefHalfScreenView(title: "\(rockets)", subtitle: "рокетов за месяц", image: Asset.AppImages.rocket.image)
		let container = PocketScalableContainer(content: PocketDivView(content: rocketsView))
		container.addTarget(action: { _ in
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: { self.present(RocketModalViewController(), animated: true, completion: nil) })
		}, for: .touchUpInside)
		stack.addArrangedSubview(container)
		
	}
	func getWeatherImage(id: Int) -> (UIImage, UIColor) {
		Logger.print(from: #function, id)
		switch true {
			case id >= 200 && id <= 232:
				return (Asset.AppImages.WeatherImages.drizzle.image, Asset.PocketColors.accent.color)
			
			case id >= 300 && id <= 321:
				return (Asset.AppImages.WeatherImages.drizzle.image, Asset.PocketColors.accent.color)
			
			case id >= 500 && id <= 531:
				return (Asset.AppImages.WeatherImages.drizzle.image, Asset.PocketColors.accent.color)
			
			case id >= 600 && id <= 622:
				return (Asset.AppImages.WeatherImages.drizzle.image, Asset.PocketColors.pocketGray.color)
			
			case id >= 701 && id <= 781:
				return (Asset.AppImages.WeatherImages.drizzle.image, Asset.PocketColors.pocketGray.color)
			
			case id == 800:
				return (Asset.AppImages.WeatherImages.sunny.image, Asset.PocketColors.pocketYellow.color)
			
			case id == 801:
				return (Asset.AppImages.WeatherImages.clouds.image, Asset.PocketColors.buttonOutlineBorder.color)
			
			case id >= 802 && id <= 804:
				return (Asset.AppImages.WeatherImages.cloudy.image, Asset.PocketColors.pocketBlack.color)
			
			default:
				return (Asset.AppImages.WeatherImages.clouds.image, Asset.PocketColors.pocketDarkBlue.color)
		}
	}
	
	// MARK: - Schedule
	private var lessons: [SALesson] = []
	private var day = 0
	func getNearestDay(for timetable: SATimetable) -> Int {
		Logger.print(from: #function, "getNearestTimetable")
		func nextDay(_ cur: Int) -> Int {
			if cur == 6 { return 0 }
			return cur+1
		}
		let todayUS = Calendar.current.dateComponents([.weekday], from: Date()).weekday ?? 0
		let today = Calendar.convertToRU(todayUS)
		
		var day = today
		
		var lessons: [SALesson]
		
		let week = SASchedule.shared.settings?.week ?? .odd
		
		lessons = timetable.get(week: week, day: day )
		
		var safeCounter = 7
		repeat {
			lessons = timetable.get(week: week, day: day )
			if lessons.isEmpty { day = nextDay(day) }
			safeCounter -= 1
		}while(lessons.isEmpty && safeCounter > 0)
		self.lessons = lessons
		Logger.print(from: #function, "end of getNearestTimetable")
		return day
		
	}
	
	func addSchedule(timetable: [SALesson], day: Int) {
		let weekdays = ["понедельник", "вторник", "среду", "четверг", "пятницу", "субботу"]
		let today = Calendar.convertToRU(Calendar.current.dateComponents([.weekday], from: Date()).weekday ?? 0)
		
		let stack = UIStackView(arrangedSubviews: lessons.map {  PocketDayView.make(lesson: $0) })
		stack.axis = .vertical
		
		let div = PocketDivView(content: stack)
		
		let container = PocketScalableContainer(content: div)
		container.addTarget(action: { _ in
			if let barControllers = self.tabBarController?.viewControllers,
				let vc = (barControllers[2] as? ScheduleTabViewController) {
				vc.scheduleDaySelect(didUpdate: day, week: .odd)
			}
			
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: { self.tabBarController?.selectedIndex = 2 })
		}, for: .touchUpInside)
		//
		//		print("Brief: \(#function) add block")
		print("Brief: \(timetable.count) add block")
		
		self.rootView.addBlock(title: "Расписание на \(today == day ? "сегодня" : weekdays[day] )", view: container )
		//		print("Brief: \(#function) added block")
		
	}
	
	// MARK: - Deadlines
	func addDeadlines() {
		let deadlineListVC = DeadlineListController(list: [])
		let deadlines = SADeadlines.shared.nearest.enumerated().filter { (index, _) in index < 5 }.map {$0.element}
		
		if deadlines.count > 0 {
			deadlineListVC.setItems(list: deadlines )
			let div = PocketDivView(content: deadlineListVC.view)
			let container = PocketScalableContainer(content: div)
			container.addTarget(action: { _ in
				DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
					self.tabBarController?.selectedIndex = 1
					if let barControllers = self.tabBarController?.viewControllers,
						let vc = (barControllers[1] as? DeadlinesTabViewController) {
						vc.rootView.deadlineListSelector.selectedIndex = 0
						vc.reloadItems()
					}
				})
			}, for: .touchUpInside)
			
			self.rootView.addBlock(title: "Ближайшие дедлайны", view: container )
		}
		
	}
	
	// MARK: - News
	func addNews() {
		let feed: [SAFeedElement] = SABrief.shared.news
		
		let stack = UIStackView(frame: .zero)
		stack.axis = .vertical
		stack.spacing = 15
		for element in feed {
			let tapContainer = PocketScalableContainer(content: self.generateNewsView(from: element, source: element.source.name))
			tapContainer.addTarget(action: { _ in
				if let url = URL(string: "vk://\(element.postUrl)") {
					UIApplication.shared.open(url, options: [:], completionHandler: { success in
						if !success { self.openPost(url: element.postUrl)}
					})
				} else { self.openPost(url: element.postUrl)}
				
			}, for: .touchUpInside)
			stack.addArrangedSubview(tapContainer)
		}
		
		self.rootView.addBlock(title: "Популярные новости", view: PocketDivView(content: stack) )
		
	}
	private func openPost(url: String) {
		let config = SFSafariViewController.Configuration()
		guard let url = URL(string: "https://\(url)") else {return}
		let vc = SFSafariViewController(url: url, configuration: config)
		vc.modalPresentationStyle = .popover
		self.present(vc, animated: true, completion: nil)
	}
	private  func generateNewsView(from element: SAFeedElement, source: String = "") -> PocketNewsView {
		let newsView = PocketNewsView()
		
		newsView.authorLabel.text = source
		newsView.titleLabel.text = element.title
		newsView.likeLabel.text = "\(element.likes)"
		
		let formatter = DateFormatter()
		formatter.locale = Locale(identifier: "Ru")
		
		formatter.dateFormat = "dd MMMM в HH:mm"
		newsView.datetimeLabel.text = formatter.string(from: element.date)
		
		NetworkManager.dataTask(url: element.imageURL ?? "") { (result) in
			switch result {
				case .success(let data):
					guard let image = UIImage(data: data) else { return }
					DispatchQueue.main.async { newsView.imageView.image = image}
				
				case .failure: break
			}
		}
		return newsView
	}
	
	// MARK: - Events
	
	func addEvents() {
		let feed: [SAFeedElement] = SABrief.shared.events
		
		let stack = UIStackView(frame: .zero)
		stack.axis = .vertical
		stack.spacing = 15
		for element in feed {
			let newsView = generateNewsView(from: element, source: element.source.name)
			newsView.datetimeLabel.snp.removeConstraints()
			newsView.datetimeLabel.snp.makeConstraints { (make) in
				make.bottom.equalTo(newsView.imageView)
				make.left.equalToSuperview()
			}
			newsView.likeIcon.removeFromSuperview()
			newsView.likeLabel.removeFromSuperview()
			let tapContainer = PocketScalableContainer(content: newsView)
			if element.postUrl.isEmpty {
				tapContainer.isUserInteractionEnabled = false
				tapContainer.isEnabled = false
			}
			tapContainer.addTarget(action: { _ in
				if let url = URL(string: "vk://\(element.postUrl)") {
					UIApplication.shared.open(url, options: [:], completionHandler: { success in
						if !success { self.openPost(url: element.postUrl)}
					})
				} else { self.openPost(url: element.postUrl)}
				
			}, for: .touchUpInside)
			stack.addArrangedSubview(tapContainer)
		}
		
		self.rootView.addBlock(title: "Предстоящие события", view: PocketDivView(content: stack) )
		
	}
	
}
