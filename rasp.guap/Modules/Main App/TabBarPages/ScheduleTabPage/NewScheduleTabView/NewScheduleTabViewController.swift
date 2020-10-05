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


class NewScheduleTabViewController: ViewController<NewScheduleTabView>{

	required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    required init() {
        super.init()
        self.tabBarItem = ESTabBarItem(PocketTabBarIcon(),title: "Расписание", image: Asset.AppImages.TabBarImages.schedule.image, tag: 0)
		self.tabBarItem.image?.accessibilityValue = Asset.AppImages.TabBarImages.schedule.name
    }
	
	
	

    
	var currentUser:SAUsers.User? {
		didSet{
			self.loadSchedule()
		}
	}
	var currentWeek:SATimetable.Week {self.timetable.get(week: .current) == self.timetable.get(week: .even) ? .even : .odd}
	var nextWeek:SATimetable.Week {self.timetable.get(week: .current) == self.timetable.get(week: .even) ? .odd : .even}
	var timetable = SATimetable()
    override func viewDidLoad() {
        self.rootView.setTitle(self.tabBarItem.title ?? "")
        
        self.rootView.selectButton.addTarget(action: { (sender) in
            let vc = TimetableFilterViewConroller()
            vc.delegate = self
			vc.currentUser = self.currentUser
            self.present(vc, animated: true, completion: nil)
        }, for: .touchUpInside)
        
		if let name = SAUserSettings.shared.group,
		   let user = SASchedule.shared.groups.get(name: name){
			self.currentUser = user
			let timetable = SASchedule.shared.get(for: user)
			if !timetable.isEmpty {
				self.timetable = timetable
			}
		}
		self.rootView.table.delegate = self
		self.rootView.table.dataSource = self
		self.rootView.table.register(NewScheduleTabTableCell.self, forCellReuseIdentifier: "dayTimetable")
	}
	
	func loadSchedule(){
		self.timetable = SATimetable()
		self.rootView.table.reloadData()
		DispatchQueue.global().async {
			
			if let user = self.currentUser{
				let timetable = SASchedule.shared.get(for: user)
				self.timetable = timetable
				DispatchQueue.main.async {
					self.rootView.title.text = user.shortName
					self.rootView.table.reloadData()
					self.rootView.table.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
				}
			}
		}
	}
	
}
extension NewScheduleTabViewController:UserChangeDelegate{
    func didSetUser(user: SAUsers.User) {
        self.currentUser = user
    }
}

extension NewScheduleTabViewController:UITableViewDelegate{

}
extension NewScheduleTabViewController:UITableViewDataSource{
	func numberOfSections(in tableView: UITableView) -> Int {
		if self.timetable.get(week: .outOfTable).isEmpty {
			return 2
		}else{
			return 3
		}
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if section == 0 {
			let curWeekDay = Calendar.convertToRU(Calendar.current.component(.weekday, from: Date()))
			return (7 - curWeekDay)
		}else if section == 1{
			return 7
		}else{
			return 1
		}
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "dayTimetable", for: indexPath)
		
		if let cell = cell as? NewScheduleTabTableCell {
			cell.controller.setTimetable(timetable: [])
			
			let formatter = DateFormatter()
			formatter.formattingContext = .beginningOfSentence
			formatter.locale = Locale(identifier: "ru")
			formatter.dateFormat = "EEEE, d MMMM"
			
			
			if indexPath.section == 0{
				cell.setupCell(self, timetable: self.timetable.get(week: .current, day: indexPath.row))
				let date = Date().addingTimeInterval(Double(3600*24*indexPath.row))
				cell.dayLabel.text = formatter.string(from: date)
				formatter.dateFormat = "EEEE, пар нет!"
				cell.placeholder.content.titleLabel.text = formatter.string(from: date)
				
				
			}else if indexPath.section == 1{
				let firstSectionCount = self.tableView(tableView, numberOfRowsInSection:0)
				let date = Date().addingTimeInterval(Double(firstSectionCount + 3600*24*indexPath.row))
				cell.dayLabel.text = formatter.string(from: date)
				cell.setupCell(self, timetable: self.timetable.get(week: self.nextWeek, day: indexPath.row))
				formatter.dateFormat = "EEEE, пар нет!"
				cell.placeholder.content.titleLabel.text = formatter.string(from: date)
			}else{
				cell.dayLabel.text = "Вне сетки"
				cell.setupCell(self, timetable: self.timetable.get(week: .outOfTable))
			}
			
		}
		cell.setNeedsUpdateConstraints()
		cell.updateConstraintsIfNeeded()
		cell.setNeedsLayout()
		cell.layoutIfNeeded()
		return cell
	}
	func generateViewForHeader(isUp:Bool, isEven:Bool)->UIView{
		let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
		let image = UIImageView(image: Asset.SystemIcons.searchDropdown.image.withRenderingMode(.alwaysTemplate))
		image.tintColor = isEven ? Asset.PocketColors.pocketDarkBlue.color : .red //Asset.PocketColors.pocketRedButtonText.color
		image.transform = isUp ? .init(rotationAngle: CGFloat.pi) : .identity
		view.addSubview(image)
		
		let label = UILabel(frame: .zero)
		label.font = FontFamily.SFProDisplay.semibold.font(size: 14)
		label.textColor = Asset.PocketColors.pocketGray.color
		label.text = isEven ? "Четная неделя" : "Нечетная неделя"
		
		view.addSubview(label)
		
		image.snp.makeConstraints { (make) in
			make.centerY.equalToSuperview()
			make.left.equalToSuperview().offset(4)
			make.width.height.equalTo(27)
		}
		
		label.snp.makeConstraints { (make) in
			make.left.equalTo(image.snp.right).offset(8)
			make.centerY.equalToSuperview()
			make.height.equalToSuperview().inset(4)
		}
		view.backgroundColor = Asset.PocketColors.pocketWhite.color
		return view
	}
	func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat { section == 1 ? 30 : 0 }
	func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat { section == 0 ? 30 : 0 }
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		if section == 1{
			return generateViewForHeader(isUp: true, isEven: currentWeek == .even)
		}
		return UIView(frame: .zero)
	}
	func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		if section == 0 {
			return generateViewForHeader(isUp: false, isEven: nextWeek == .even)
		}
		return UIView(frame: .zero)

	}
	
}
