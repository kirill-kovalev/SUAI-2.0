//
//  MainTabBarController.swift
//  rasp.guap
//
//  Created by Кирилл on 12.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit
import SUAI_API
import ESTabBarController_swift

class MainTabBarController : ESTabBarController{
    init(){
        super.init(nibName: nil, bundle: nil)
        self.viewControllers = [
            FeedTabViewController(),
            DeadlinesTabViewController(),
            ScheduleTabViewController(),
            InfoTabViewController(),
            ProfileTabViewController()
        ]
        
        let newUserSetting = SAUserSettings.fromServer()
        if newUserSetting != nil {
            SAUserSettings.shared = newUserSetting
        }
        let startPage = SAUserSettings.shared?.idtab  ?? 3
        self.selectedIndex = startPage - 1
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.layer.cornerRadius = 10
        self.tabBar.layer.masksToBounds = true
        self.tabBar.barTintColor = Asset.PocketColors.pocketWhite.color
        self.tabBar.layer.shadowColor = Asset.PocketColors.pocketShadow.color.cgColor
        self.tabBar.layer.shadowRadius = 10
        self.tabBar.layer.shadowOffset = .zero
        
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
