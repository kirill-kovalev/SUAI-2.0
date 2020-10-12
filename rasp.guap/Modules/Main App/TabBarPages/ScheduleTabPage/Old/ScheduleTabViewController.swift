//
//  ScheduleTabViewController.swift
//  rasp.guap
//
//  Created by Кирилл on 12.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit
import ESTabBarController_swift
import SUAI_API

class ScheduleTabViewController: ViewController<ScheduleTabView> {
    required init() {
        super.init()
        self.tabBarItem = ESTabBarItem(PocketTabBarIcon(), title: "Расписание", image: Asset.AppImages.TabBarImages.schedule.image, tag: 0)
		self.tabBarItem.image?.accessibilityValue = Asset.AppImages.TabBarImages.schedule.name
    }
    
    var tableController: TimetableViewController = TimetableViewController(timetable: [])
    var daySelectController = ScheduleDaySelectViewController()
    
    var timetable: SATimetable = SATimetable()
    
    var currentUser: SAUsers.User?
    
    override func loadView() {
        super.loadView()
        
        self.addChild(tableController)
        self.rootView.pocketDiv.addSubview(tableController.view)
        self.tableController.didMove(toParent: self)
        self.tableController.view.snp.removeConstraints()
        self.tableController.view.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalToSuperview()
        }
        
        self.addChild(daySelectController)
        self.rootView.header.addSubview(daySelectController.view)
        daySelectController.didMove(toParent: self)
        daySelectController.view.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().inset(10)
            make.top.equalTo(self.rootView.title.snp.bottom).offset(10)
			make.bottom.equalToSuperview().inset(8)
        }
        
    }
    
    override func viewDidLoad() {
        self.rootView.setTitle(self.tabBarItem.title ?? "")
        
        self.rootView.selectButton.addTarget(action: { (_) in
            let vc = TimetableFilterViewConroller()
            vc.delegate = self
			vc.currentUser = self.currentUser
            self.present(vc, animated: true, completion: nil)
        }, for: .touchUpInside)
        
        self.rootView.todayButton.addTarget(action: { (_) in
            self.setToday()
            UINotificationFeedbackGenerator().notificationOccurred(.warning)
        }, for: .touchUpInside)
        
        daySelectController.delegate = self
        tableController.cellDelegate = self
        daySelectController.update()
		
        DispatchQueue.global(qos: .background).async {
			guard let groupName = SAUserSettings.shared.group else {
				Logger.print(from: #function, "SAUserSettings.shared?.group is nil")
				_ =	UIApplication.shared.appDelegate.application(UIApplication.shared, didFinishLaunchingWithOptions: nil)
                return
            }
            self.currentUser = SASchedule.shared.groups.get(name: groupName)
            self.setToday()
        }
        
		let gesture = UIPanGestureRecognizer(target: self, action: #selector(self.swipePages(_:)) )
		self.rootView.addGestureRecognizer(gesture)
	}
	
	@objc func swipePages(_ sender: UIPanGestureRecognizer) {
		let index = daySelectController.rootView.daySelector.selectedIndex
		let translation = sender.translation(in: self.rootView)
		if sender.state == .ended,
		   abs(translation.x)/2 > abs(translation.y) {
			if translation.x > self.rootView.bounds.width/2 || sender.velocity(in: self.rootView).x > 25 {
				if  index == 0 {UINotificationFeedbackGenerator().notificationOccurred(.error);return}
				daySelectController.rootView.daySelector.selectedIndex -= 1
			} else if translation.x < -self.rootView.bounds.width/2 || sender.velocity(in: self.rootView).x < -25 {
				if index == daySelectController.rootView.daySelector.count-1 {UINotificationFeedbackGenerator().notificationOccurred(.error);return}
					daySelectController.rootView.daySelector.selectedIndex += 1
			}
			self.daySelectController.didSelect(daySelectController.rootView.daySelector.selectedIndex)
		}
		
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		DispatchQueue.global(qos: .background).async {
			if let user = self.currentUser {
				let newTimetable = SASchedule.shared.load(for: user)
				if newTimetable.isEmpty {
					MainTabBarController.Snack(status: .err, text: "Не удалось обновить расписание")
				} else {
					if AppSettings.isTimetableNotificationsEnabled,
						NotificationManager.shared.isAuth {
						_ = newTimetable.setupNotifications()
					}
					
					DispatchQueue.main.async { self.daySelectController.update() }
					self.setDay(week: self.daySelectController.week, day: self.daySelectController.day)
				}
			}
        }
	}

    private func setToday() {
        let today = Calendar.convertToRU(Calendar(identifier: .gregorian).dateComponents([.weekday], from: Date()).weekday!)
        DispatchQueue.global(qos: .background).async {
            self.setDay(week: SASchedule.shared.settings?.week ?? .odd, day: today )
        }
        
    }
    
    private func setDay(week: SATimetable.Week = .odd, day: Int = 0) {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "Ru")
		let isToday: Bool = (
				   week == SASchedule.shared.settings?.week &&
				   day == Calendar.convertToRU( calendar.dateComponents([.weekday], from: Date()).weekday! )
			   )
        
        DispatchQueue.main.async {
            if day >= 0 {
				self.rootView.placeholder.title = calendar.weekdaysRu[day].capitalized + ", пар нет!"
                self.rootView.dayLabel.text = (calendar.weekdaysRu[day].capitalized + ", \(week == .odd ? "не" : "")четная неделя")
			} else {
				self.rootView.placeholder.title = "Вне сетки пар нет!"
                self.rootView.dayLabel.text = ("Вне сетки")
			}
			self.rootView.todayButton.isHidden = isToday
        }

        DispatchQueue.main.async {
			self.daySelectController.update()
            self.daySelectController.set(day: day, week: week)
        }
		self.setTimetable(week: week, day: day )
    }
    
    private func setTimetable(week: SATimetable.Week = .odd, day: Int = 0) {
        guard let user = self.currentUser else {
			Logger.print(from: #function, "curUser is nil")
            return
        }

        DispatchQueue.main.async {
            self.rootView.showIndicator(show: true)
            self.rootView.setTitle(user.shortName)
            
            self.tableController.tableView.isHidden = true
        }
        
        self.timetable = SASchedule.shared.get(for: user )
		
        let dayTimetable = self.timetable.get(week: week, day: day)
        
        DispatchQueue.main.async {
            self.tableController.tableView.isHidden = dayTimetable.isEmpty
            
            self.rootView.showNoLesson(show: dayTimetable.isEmpty)
            
            if !self.timetable.isEmpty {
                self.tableController.setTimetable(timetable: dayTimetable)
				self.rootView.showIndicator(show: false)
			} else {
				MainTabBarController.Snack(status: .err, text: "Не удалось загрузить расписание")
				self.tableController.setTimetable(timetable: [])
				self.daySelectController.update()
			}
            
        }
		
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension ScheduleTabViewController: ScheduleDaySelectDelegate {
    func scheduleDaySelect(didUpdate day: Int, week: SATimetable.Week) {
        DispatchQueue.global(qos: .background).async {
			Logger.print(from: #function, "set week\(week); day \(day)")
            self.setDay(week: week, day: day)
        }
        
    }
    
    func shouldShow(day: Int, week: SATimetable.Week) -> Bool {
		Logger.print(from: #function, "day: \(day); week: \(week) ; get:\(self.timetable.get(week: week, day: day).count)")
        return !self.timetable.get(week: week, day: day).isEmpty
    }
    
}

extension ScheduleTabViewController: UserChangeDelegate {
    func didSetUser(user: SAUsers.User) {
        self.currentUser = user
		self.daySelectController.update()
        DispatchQueue.global(qos: .background).async {
            self.setDay(week: self.daySelectController.week, day: self.daySelectController.day)
        }
    }
}
