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
    }
    
    var tt:TimetableViewController = TimetableViewController(timetable: [])
    
    override func loadView() {
        super.loadView()
        self.addChild(tt)
        self.rootView.pocketDiv.addSubview(tt.view)
        self.tt.didMove(toParent: self)
        self.tt.view.snp.removeConstraints()
        self.tt.view.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalToSuperview()
        }
        
        
    }
    
    override func viewDidLoad() {
        self.rootView.setTitle(self.tabBarItem.title ?? "")
        
        DispatchQueue.global(qos: .background).async {
            self.showTimetable()
        }
        
    }
    
    func showTimetable(){
        DispatchQueue.main.async {

            self.rootView.loadingIndicator.startAnimating()
        }
        guard let user = Schedule.shared.groups.get(name: "1611") else{
                                                                print("user not found")
                                                                return
                                                            }
        let timetable = Schedule.shared.get(for: user )
        let dayTimetable = timetable.get(week: .even, day: 0)
        
        DispatchQueue.main.async {
            self.rootView.loadingIndicator.stopAnimating()
            self.rootView.setTitle(user.Name)
            self.tt.setTimetable(timetable: dayTimetable)
        }
        
    }

    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
