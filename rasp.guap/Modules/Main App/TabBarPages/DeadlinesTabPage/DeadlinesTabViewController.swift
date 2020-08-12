//
//  FeedTabViewController.swift
//  rasp.guap
//
//  Created by Кирилл on 12.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit
import ESTabBarController_swift

class DeadlinesTabViewController: ViewController<DeadlinesTabView> {
    required init() {
        super.init()
        self.tabBarItem = ESTabBarItem(DeadineCustomTabBarIcon(), title: nil/*"Дедлайны"*/, image: Asset.AppImages.TabBarImages.deadlines.image, selectedImage:nil, tag: 1)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
