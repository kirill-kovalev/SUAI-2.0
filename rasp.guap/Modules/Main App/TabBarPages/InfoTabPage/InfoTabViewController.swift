//
//  FeedTabViewController.swift
//  rasp.guap
//
//  Created by Кирилл on 12.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit
import ESTabBarController_swift

class InfoTabViewController: ViewController<InfoTabView> {
    required init() {
           super.init()
        self.tabBarItem = ESTabBarItem(PocketTabBarIcon(),title: nil/*"Справочник"*/, image: Asset.AppImages.TabBarImages.info.image, tag: 3)
       }
       required init?(coder: NSCoder) {
           super.init(coder: coder)
       }
}
