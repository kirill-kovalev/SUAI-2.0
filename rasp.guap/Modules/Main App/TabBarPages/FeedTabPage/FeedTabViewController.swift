//
//  FeedTabViewController.swift
//  rasp.guap
//
//  Created by Кирилл on 12.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit
import ESTabBarController_swift

class FeedTabViewController: ViewController<FeedTabView> {
    required init() {
        super.init()
        let tabImage = Asset.AppImages.TabBarImages.feed.image
        self.tabBarItem = ESTabBarItem(PocketTabBarIcon(),title: nil/*"Новости"*/, image: tabImage , tag: 0)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
