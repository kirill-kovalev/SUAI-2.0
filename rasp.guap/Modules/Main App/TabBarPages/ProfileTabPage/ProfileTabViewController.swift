//
//  FeedTabViewController.swift
//  rasp.guap
//
//  Created by Кирилл on 12.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit
import ESTabBarController_swift

class ProfileTabViewController: ViewController<ProfileTabView> {
    required init() {
        super.init()
        self.tabBarItem = ESTabBarItem(PocketTabBarIcon(),title: nil/*"Настройки"*/, image: Asset.AppImages.TabBarImages.profile.image, tag: 4)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
