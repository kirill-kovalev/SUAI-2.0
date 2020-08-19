//
//  FeedTabViewController.swift
//  rasp.guap
//
//  Created by Кирилл on 12.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit
import SUAI_API
import ESTabBarController_swift

class DeadlinesTabViewController: ViewController<DeadlinesTabView> {
    required init() {
        super.init()
        self.tabBarItem = ESTabBarItem(DeadineCustomTabBarIcon(), title: "Дедлайны", image: Asset.AppImages.TabBarImages.deadlines.image, selectedImage:nil, tag: 1)
        self.rootView.setTitle(self.tabBarItem.title ?? "")
    }
    
    let groupSelector = DeadlineGroupSelectController()
    let deadlineList = DeadlineListController()
    
    override func loadView() {
        super.loadView()
        self.addChild(groupSelector)
        self.rootView.header.addSubview(groupSelector.stackView)
        groupSelector.didMove(toParent: self)
        groupSelector.stackView.snp.makeConstraints { (make) in
            make.top.equalTo(self.rootView.title.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(10)
            make.right.lessThanOrEqualToSuperview()
            make.bottom.equalToSuperview()
        }
        
        self.addChild(deadlineList)
        self.rootView.pocketDiv.addSubview(deadlineList.view)
        deadlineList.didMove(toParent: self)
        deadlineList.view.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
    }
    override func viewDidLoad() {
        print(SADeadlines.shared.open)
        deadlineList.setItems(list: SADeadlines.shared.open)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
