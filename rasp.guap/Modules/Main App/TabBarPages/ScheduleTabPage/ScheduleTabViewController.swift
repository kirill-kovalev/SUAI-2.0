//
//  FeedTabViewController.swift
//  rasp.guap
//
//  Created by Кирилл on 12.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit
import ESTabBarController_swift

class ScheduleTabViewController: ViewController<ScheduleTabView>{

    
    required init() {
        super.init()
        self.tabBarItem = ESTabBarItem(PocketTabBarIcon(),title: "Расписание", image: Asset.AppImages.TabBarImages.schedule.image, tag: 0)
    }
    
    var tableController:TimetableViewController = TimetableViewController(timetable: [])
    var daySelectController = ScheduleDaySelectViewController()
    
    var timetable:Timetable = Timetable()
    
    override func loadView() {
        super.loadView()
        
        
        self.addChild(tableController)
        self.rootView.pocketDiv.addSubview(tableController.view)
        self.tableController.didMove(toParent: self)
        self.tableController.view.snp.removeConstraints()
        self.tableController.view.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalToSuperview()
        }
        
        
        
        daySelectController.delegate = self
        
        self.addChild(daySelectController)
        self.rootView.header.addSubview(daySelectController.view)
        daySelectController.didMove(toParent: self)
        daySelectController.view.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().inset(10)
            
            make.top.equalTo(self.rootView.title.snp.bottom).offset(8)
            make.bottom.equalToSuperview()
        }
        
        
    }
    
    override func viewDidLoad() {
        self.rootView.setTitle(self.tabBarItem.title ?? "")
        
        self.rootView.selectButton.addTarget(action: { (sender) in
            let vc = TimetableFilterViewConroller()
            self.present(vc, animated: true, completion: nil)
        }, for: .touchUpInside)
        self.rootView.todayButton.addTarget(action: { (sender) in
            let today = Calendar.convertToRU(Calendar(identifier: .gregorian).dateComponents([.weekday], from: Date()).weekday!)
            self.setTimetable(week: Schedule.shared.settings!.week, day: today )
            self.daySelectController.set(day: today, week: Schedule.shared.settings!.week )
        }, for: .touchUpInside)
        
        Schedule.shared.current.user = Schedule.shared.groups.get(name: "М911")
        Schedule.shared.current.delegate = self
        setTimetable()
    }
    
    
    func setTimetable(week: Timetable.Week = .odd , day: Int = 0){
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "Ru")
        
        self.rootView.dayLabel.text = (calendar.weekdaysRu[day].capitalized + ", \(week == .odd ? "не" : "")четная неделя")
        self.rootView.loadingIndicator.startAnimating()
        self.tableController.setTimetable(timetable: [])
        
        
        if week == Schedule.shared.settings?.week, day == Calendar.convertToRU(calendar.dateComponents([.weekday], from: Date()).weekday!) {
            self.rootView.todayButton.isHidden = true
        }else{
            self.rootView.todayButton.isHidden = false
        }
        

        DispatchQueue.global(qos: .background).async {
                   guard let user = Schedule.shared.current.user else{
                                                                       print("user not set")
                                                                       return
                                                                   }
                   self.timetable = Schedule.shared.get(for: user )
                   let dayTimetable = self.timetable.get(week: week, day: day)
                   
                    DispatchQueue.main.async {
                        self.rootView.loadingIndicator.stopAnimating()
                        
                        
                        self.rootView.setTitle(user.shortName)
                        self.tableController.setTimetable(timetable: dayTimetable)
                        self.daySelectController.update()
                        
                    }
        }
    }
    
    

    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension ScheduleTabViewController:ScheduleDaySelectDelegate {
    func scheduleDaySelect(didUpdate day: Int, week: Timetable.Week) {
        setTimetable(week: week, day: day)
    }
    
    func shouldShow(day: Int,week:Timetable.Week) -> Bool {
        return !self.timetable.get(week: week, day: day).isEmpty
    }
    
}

extension ScheduleTabViewController:scheduleTracker{
    func didChange() {
        setTimetable(week: self.daySelectController.week, day: self.daySelectController.day)
    }
}
