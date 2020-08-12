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
        self.tabBarItem = ESTabBarItem(PocketTabBarIcon(),title: nil/*"Расписание"*/, image: Asset.AppImages.TabBarImages.schedule.image, tag: 0)
       }
       required init?(coder: NSCoder) {
           super.init(coder: coder)
       }
}
