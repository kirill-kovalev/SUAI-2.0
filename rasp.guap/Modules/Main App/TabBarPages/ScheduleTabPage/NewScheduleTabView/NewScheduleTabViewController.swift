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

class NewScheduleTabViewController: ViewController<NewScheduleTabView> {
	required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    required init() {
        super.init()
        self.tabBarItem = ESTabBarItem(PocketTabBarIcon(), title: "Расписание", image: Asset.AppImages.TabBarImages.schedule.image, tag: 0)
		self.tabBarItem.image?.accessibilityValue = Asset.AppImages.TabBarImages.schedule.name
    }
    
	var currentUser: SAUsers.User? {
		didSet {
			self.loadSchedule()
		}
	}
	var currentWeek: SATimetable.Week {self.timetable.get(week: .current) == self.timetable.get(week: .even) ? .even : .odd}
	var nextWeek: SATimetable.Week {self.timetable.get(week: .current) == self.timetable.get(week: .even) ? .odd : .even}
	var timetable = SATimetable()
    override func viewDidLoad() {
        self.rootView.setTitle(self.tabBarItem.title ?? "")
        
        self.rootView.selectButton.addTarget(action: { (_) in
            let vc = TimetableFilterViewConroller()
            vc.delegate = self
			vc.currentUser = self.currentUser
            self.present(vc, animated: true, completion: nil)
        }, for: .touchUpInside)
        
		DispatchQueue.global().async {
			self.setCurrentUser()
		}
		
		self.rootView.table.delegate = self
		self.rootView.table.dataSource = self
		self.rootView.table.register(NewScheduleTabTableCell.self, forCellReuseIdentifier: "dayTimetable")
	}
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		self.rootView.table.reloadData()
	}
	
	func setCurrentUser() {
		if let name = SAUserSettings.shared.group,
		   let user = SASchedule.shared.groups.get(name: name) {
			self.currentUser = user
//			let timetable = SASchedule.shared.get(for: user)
//			if !timetable.isEmpty {
//				self.timetable = timetable
//			}
		}
	}
	
	func loadSchedule() {
		self.timetable = SATimetable()
		DispatchQueue.main.async {
			self.rootView.table.isHidden = true
			self.rootView.table.reloadData()
			self.rootView.activityIndicator.startAnimating()
		}
		DispatchQueue.global().async {
			if let user = self.currentUser {
				let timetable = SASchedule.shared.get(for: user)
				self.timetable = timetable
				DispatchQueue.main.async {
					self.rootView.title.text = user.shortName
					self.rootView.activityIndicator.stopAnimating()
					self.rootView.table.reloadData()
					self.rootView.table.isHidden = false
					self.rootView.table.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
				}
			}
		}
	}
	
}
extension NewScheduleTabViewController: UserChangeDelegate {
    func didSetUser(user: SAUsers.User) {
        self.currentUser = user
    }
}

extension NewScheduleTabViewController: UITableViewDelegate {
}
extension NewScheduleTabViewController: UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		if self.timetable.get(week: .outOfTable).isEmpty {
			return self.curWeekDay == 0 ? 2 : 3
		} else {
			return self.curWeekDay == 0 ? 3 : 4
		}
	}
	
	var curWeekDay: Int { Calendar.convertToRU(Calendar.current.component(.weekday, from: Date()))}
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		switch section {
			case 0: return (7 - curWeekDay) + 1
			case 1: return 7 + 1
			case 2: return curWeekDay
			default: return 1
		}
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let separatorView = UIView(frame: .zero)
		separatorView.backgroundColor = Asset.PocketColors.pocketGray.color.withAlphaComponent(0.3)
		separatorView.layer.cornerRadius = 1
		separatorView.layer.opacity = 0.3
		
		if indexPath.section == 0, indexPath.row == (7 - curWeekDay) {
			let cell = self.generateViewForHeader(isUp: true, isEven: currentWeek == .even)
			cell.addSubview(separatorView)
			separatorView.snp.makeConstraints { (make) in
				make.centerX.bottom.equalToSuperview()
				make.width.equalToSuperview().inset(8)
				make.height.equalTo(2)
			}
			return cell
		}
		if indexPath.section == 1, indexPath.row == 7 {
			let cell = self.generateViewForHeader(isUp: true, isEven: nextWeek == .even)
			cell.addSubview(separatorView)
			separatorView.snp.makeConstraints { (make) in
				make.centerX.bottom.equalToSuperview()
				make.width.equalToSuperview().inset(12)
				make.height.equalTo(1)
			}
			return cell
		}
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "dayTimetable", for: indexPath)
		
		if let cell = cell as? NewScheduleTabTableCell {
			cell.controller.setTimetable(timetable: [])
			
			let formatter = DateFormatter()
			formatter.formattingContext = .beginningOfSentence
			formatter.locale = Locale(identifier: "ru")
			formatter.dateFormat = "EEEE, d MMMM"
			
			switch indexPath.section {
				case 0:
					cell.setupCell(self, timetable: self.timetable.get(week: self.currentWeek, day: curWeekDay + indexPath.row))
					let date = Date().addingTimeInterval(Double(3600*24*indexPath.row))
					cell.dayLabel.text = formatter.string(from: date)
					
					formatter.dateFormat = "EEEE"
					cell.placeholder.content.titleLabel.text = "\(formatter.string(from: date)), пар нет!"
				case 1:
					cell.setupCell(self, timetable: self.timetable.get(week: self.nextWeek, day: indexPath.row))
					let firstSectionCount = self.tableView(tableView, numberOfRowsInSection: 0)-1
					let day = Double(firstSectionCount + indexPath.row)
					let date = Date().addingTimeInterval(3600*24*day)
					cell.dayLabel.text = formatter.string(from: date)
					
					formatter.dateFormat = "EEEE"
					cell.placeholder.content.titleLabel.text = "\(formatter.string(from: date)), пар нет!"
				case 2:
					cell.setupCell(self, timetable: self.timetable.get(week: self.currentWeek, day: indexPath.row))
					let firstSectionCount = self.tableView(tableView, numberOfRowsInSection: 0)-1
					let day = Double(firstSectionCount + indexPath.row + 7 )
					let date = Date().addingTimeInterval(3600*24*day)
					cell.dayLabel.text = formatter.string(from: date)
					
					formatter.dateFormat = "EEEE"
					cell.placeholder.content.titleLabel.text = "\(formatter.string(from: date)), пар нет!"
				default:
					cell.dayLabel.text = "Вне сетки"
					cell.placeholder.content.titleLabel.text = "Вне сетки, пар нет!"
					cell.setupCell(self, timetable: self.timetable.get(week: .outOfTable))
			}
			
		}
		
		cell.setNeedsUpdateConstraints()
		cell.updateConstraintsIfNeeded()
		cell.setNeedsLayout()
		cell.layoutIfNeeded()
		return cell
	}
	func generateViewForHeader(isUp: Bool, isEven: Bool) -> UITableViewCell {
		let view = UITableViewCell(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
		view.backgroundColor = Asset.PocketColors.headerBackground.color
		
		let image = UIView(frame: .zero)
		image.backgroundColor = isEven ? Asset.PocketColors.pocketDarkBlue.color : .red
		image.layer.cornerRadius = 2.5
		view.addSubview(image)
		image.snp.makeConstraints { (make) in
			make.centerY.equalToSuperview()
			make.left.equalToSuperview().offset(10)
			make.width.height.equalTo(5)
		}
		
		let label = UILabel(frame: .zero)
		label.font = FontFamily.SFProDisplay.semibold.font(size: 14)
		label.textColor = Asset.PocketColors.pocketGray.color
		label.text = isEven ? "Четная неделя" : "Нечетная неделя"
		view.addSubview(label)
		label.snp.makeConstraints { (make) in
			make.left.equalTo(image.snp.right).offset(8)
			make.centerY.equalToSuperview()
			make.height.equalToSuperview().inset(4)
		}
		
		return view
	}
	func generateTodayLabel() -> Button {
		let button = Button(frame: .zero)
		let week = self.currentWeek == .even ? "четная" : "нечетная"
				
		button.titleLabel?.font = FontFamily.SFProDisplay.bold.font(size: 14)
		button.contentHorizontalAlignment = .left
		button.backgroundColor = Asset.PocketColors.headerBackground.color
		button.addTarget(action: { (_) in self.setCurrentUser() }, for: .touchUpInside)
		button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8 + 15, bottom: 0, right: 0)
		
		let image = UIView(frame: .zero)
		image.backgroundColor = self.currentWeek == .even ? Asset.PocketColors.pocketDarkBlue.color : .red
		image.layer.cornerRadius = 2.5
		button.addSubview(image)
		
		image.snp.makeConstraints { (make) in
			make.centerY.equalToSuperview()
			make.left.equalToSuperview().offset(10)
			make.width.height.equalTo(5)
		}
		
		if let curUser = self.currentUser,
			let settingsGroup = SAUserSettings.shared.group,
			let weekNum = SASchedule.shared.settings?.weekNum {
			if curUser.Name == settingsGroup {
				button.isEnabled = false
				
				let formatter = DateFormatter()
				formatter.locale = Locale(identifier: "ru")
				formatter.dateFormat = "d MMMM"
				let todayStr = formatter.string(from: Date())
				
				button.setTitleColor(Asset.PocketColors.pocketGray.color, for: .normal)
				button.setTitle("\(todayStr), \(week) неделя (\(weekNum))", for: .disabled)
				return button
			}
			
		}
		
		button.isEnabled = true
		button.setTitle("Вернуться к расписанию \(SAUserSettings.shared.group ?? "")", for: .normal)
		button.setTitleColor(Asset.PocketColors.accent.color, for: .normal)
		
		return button
	}
	
	func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat { [0, 1, 2].contains(section) ? 35 : 0}

	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		switch section {
			case 0 : return generateTodayLabel()
			case 1 : return generateViewForHeader(isUp: true, isEven: currentWeek != .even)
			case 2 : return generateViewForHeader(isUp: true, isEven: nextWeek != .even)
			default: return nil
		}
	}
	
}
