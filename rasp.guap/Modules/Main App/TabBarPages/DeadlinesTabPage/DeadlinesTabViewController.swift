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
        groupSelector.delegate = self
        
        
        self.addChild(deadlineList)
        self.rootView.pocketDiv.addSubview(deadlineList.view)
        deadlineList.didMove(toParent: self)
        deadlineList.view.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        deadlineList.delegate = self
    }
    override func viewDidLoad() {
        deadlineList.setItems(list: SADeadlines.shared.open)
        let icon = self.tabBarItem as! ESTabBarItem
        icon.badgeValue = "\(SADeadlines.shared.nearest.count)"
        icon.badgeColor = .green
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension DeadlinesTabViewController:DeadlineGroupSelectControllerDelegate{
    func didSelect(group: SADeadlineGroup) {
        switch group {
        case .closed:
            self.deadlineList.setItems(list: SADeadlines.shared.closed)
            break
        case .nearest:
            self.deadlineList.setItems(list: SADeadlines.shared.nearest)
            break
        case .open:
            self.deadlineList.setItems(list: SADeadlines.shared.open)
            break
        }
    }
}

extension DeadlinesTabViewController:DeadlineListDelegate{
    func deadlineDidSelected(deadline: SADeadline) {
        self.present(DeadlineInfoModalViewController(deadline: deadline), animated: true, completion: nil)
    }
    
    func deadlineDidChecked(deadline: SADeadline) {

        DispatchQueue.global(qos: .background).async {
            if deadline.closed == 0 {
                SADeadlines.shared.close(deadline: deadline)
            }else
            {
                SADeadlines.shared.reopen(deadline: deadline)
            }
            SADeadlines.shared.loadFromServer()
            DispatchQueue.main.async {
                switch self.groupSelector.current {
                case .closed:
                    self.deadlineList.setItems(list: SADeadlines.shared.closed)
                    break
                case .nearest:
                    self.deadlineList.setItems(list: SADeadlines.shared.nearest)
                    break
                case .open:
                    self.deadlineList.setItems(list: SADeadlines.shared.open)
                    break
                }
            }
        }
    }
    
    
}
