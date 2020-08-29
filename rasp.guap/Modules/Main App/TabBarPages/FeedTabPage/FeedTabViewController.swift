//
//  FeedTabViewController.swift
//  rasp.guap
//
//  Created by Кирилл on 12.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit
import ESTabBarController_swift
import SUAI_API

class FeedTabViewController: ViewController<FeedTabView> {
    

    let Feed = SANews()
    let pages = UIPageViewController()
    
    override func viewDidLoad() {
        let tabImage = Asset.AppImages.TabBarImages.feed.image
        self.tabBarItem = ESTabBarItem(PocketTabBarIcon(),title:"Новости", image: tabImage , tag: 0)
        self.rootView.setTitle(self.tabBarItem.title ?? "")
        
        Feed.loadSourceList()
        
//        let btn = SwitchSelectorButton(title: "Сводка", titleColor: Asset.PocketColors.pocketGray.color, selectedTitleColor: Asset.PocketColors.buttonOutlineBorder.color, backgroundColor: Asset.PocketColors.pocketBlue.color)
//        self.rootView.sourceSelector.add(btn)
        
        for s in Feed.sources{
            let btn = SwitchSelectorButton(title: s.name, titleColor: Asset.PocketColors.pocketGray.color, selectedTitleColor: Asset.PocketColors.buttonOutlineBorder.color, backgroundColor: Asset.PocketColors.pocketBlue.color)
            self.rootView.sourceSelector.add(btn)
        }
        self.rootView.sourceSelector.switchDelegate = self
        

    }

}
extension FeedTabViewController:SwitchSelectorDelegate {
    func didSelect(_ index: Int) {
        print("selected: \(index)")
    }
}

