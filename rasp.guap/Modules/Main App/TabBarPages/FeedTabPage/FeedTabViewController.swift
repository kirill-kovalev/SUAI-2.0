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
    

    let news = SANews()
    let feedVC = FeedListViewController()
    
    override func viewDidLoad() {
        let tabImage = Asset.AppImages.TabBarImages.feed.image
        self.tabBarItem = ESTabBarItem(PocketTabBarIcon(),title:"Новости", image: tabImage , tag: 0)
        self.rootView.setTitle(self.tabBarItem.title ?? "")
        

        self.rootView.sourceSelector.switchDelegate = self
        
        self.addChild(feedVC)
        self.rootView.addSubview(feedVC.view)
        feedVC.view.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalToSuperview()
        }
        self.feedVC.didMove(toParent: self)
        
        DispatchQueue.global(qos: .default).async {
            self.news.loadSourceList()
            for s in self.news.sources{
                let btn = SwitchSelectorButton(title: s.name, titleColor: Asset.PocketColors.pocketGray.color, selectedTitleColor: Asset.PocketColors.buttonOutlineBorder.color, backgroundColor: Asset.PocketColors.pocketBlue.color)
                DispatchQueue.main.async { self.rootView.sourceSelector.add(btn) }
            }
            
            DispatchQueue.main.async {
                self.rootView.sourceSelector.selectedIndex = 0
                self.didSelect(0)
            }
        }
        
        
        
            
        
    }
    
    

}
extension FeedTabViewController:SwitchSelectorDelegate {
    func didSelect(_ index: Int) {
        self.feedVC.stream = news.streams[index]
    }
}

