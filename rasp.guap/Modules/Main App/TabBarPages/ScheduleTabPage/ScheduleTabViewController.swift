//
//  FeedTabViewController.swift
//  rasp.guap
//
//  Created by Кирилл on 12.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit
import ESTabBarController_swift

class ScheduleTabViewController: ViewController<ScheduleTabView> {
    required init() {
        super.init()
        self.tabBarItem = ESTabBarItem(PocketTabBarIcon(),title: "Расписание", image: Asset.AppImages.TabBarImages.schedule.image, tag: 0)
        self.rootView.setTitle(self.tabBarItem.title ?? "")
    }
    var tt:TimetableViewController! = nil
    override func viewDidLoad() {
        guard let user = Schedule.shared.groups.get(name: "1911") else{
                                                                print("user not found")
                                                                return
                                                            }
        let timetable = Schedule.shared.get(for: user )
        let dayTimetable = timetable.get(week: .even, day: 3)
        
        self.tt = TimetableViewController(timetable: dayTimetable)
        self.tt.setTimetable(timetable: dayTimetable)
        self.addChild(tt)
        self.rootView.pocketDiv.addSubview(tt.view)
        self.tt.didMove(toParent: self)
        self.tt.view.snp.removeConstraints()
        self.tt.view.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalToSuperview()
        }
    }

    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
