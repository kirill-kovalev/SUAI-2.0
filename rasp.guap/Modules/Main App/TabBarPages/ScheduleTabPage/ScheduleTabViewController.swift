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
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func showTimetable(week: Timetable.Week = .odd , day: Int = 0){
        DispatchQueue.main.async {

            self.rootView.loadingIndicator.startAnimating()
        }
        guard let user = Schedule.shared.groups.get(name: "М911") else{
                                                                print("user not found")
                                                                return
                                                            }
        self.timetable = Schedule.shared.get(for: user )
        let dayTimetable = self.timetable.get(week: week, day: day)
        
        DispatchQueue.main.async {
            self.rootView.loadingIndicator.stopAnimating()
            self.rootView.setTitle(user.Name)
            self.tableController.setTimetable(timetable: dayTimetable)
            self.daySelectController.update()
        }

        
        
    }

    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension ScheduleTabViewController:ScheduleDaySelectDelegate {
    func scheduleDaySelect(didUpdate day: Int, week: Timetable.Week) {
        showTimetable(week: week, day: day)
    }
    
    func shouldShow(day: Int,week:Timetable.Week) -> Bool {
        return !self.timetable.get(week: week, day: day).isEmpty
    }
    
}
