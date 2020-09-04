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
    

    let news = SANews.shared
    
    lazy var feedVC:FeedListViewController = {
        let feedVC = FeedListViewController()
        self.addChild(feedVC)
        self.rootView.addSubview(feedVC.view)
        feedVC.view.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalToSuperview()
        }
        feedVC.didMove(toParent: self)
        return feedVC
    }()
    
    lazy var briefVC:FeedBriefInfoViewController = {
        let briefVC = FeedBriefInfoViewController()
        self.addChild(briefVC)
        self.rootView.addSubview(briefVC.view)
        briefVC.view.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalToSuperview()
        }
        briefVC.didMove(toParent: self)
        return briefVC
    }()
	
	required init() {
		super.init()
		let tabImage = Asset.AppImages.TabBarImages.feed.image
        self.tabBarItem = ESTabBarItem(PocketTabBarIcon(),title:"Новости", image: tabImage , tag: 0)
	}
	
	required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
	
    override func viewDidLoad() {
        
        self.rootView.setTitle(self.tabBarItem.title ?? "")
        

        self.rootView.sourceSelector.switchDelegate = self
		self.rootView.sourceSelector.selectedIndex = 0
        reloadSources()
        showBrief()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
		self.rootView.sourceSelector.updateView()
		if news.sources.count == 0 {
			reloadSources()
		}
    }
	func reloadSources(){
		
		self.rootView.sourceSelector.add(SwitchSelectorButton(title: "Сводка", titleColor: Asset.PocketColors.pocketGray.color, selectedTitleColor: Asset.PocketColors.buttonOutlineBorder.color, backgroundColor: Asset.PocketColors.pocketBlue.color))
		DispatchQueue.global(qos: .default).async {
            self.news.loadSourceList()
			DispatchQueue.main.async{self.rootView.sourceSelector.clear()}
            for s in self.news.sources{
                let btn = SwitchSelectorButton(title: s.name, titleColor: Asset.PocketColors.pocketGray.color, selectedTitleColor: Asset.PocketColors.buttonOutlineBorder.color, backgroundColor: Asset.PocketColors.pocketBlue.color)
                DispatchQueue.main.async {
					self.rootView.sourceSelector.add(btn)
					self.rootView.sourceSelector.updateView()
				}
            }
            for stream in self.news.streams {
                DispatchQueue.global(qos: .utility).async {
                    stream.reload()
                    DispatchQueue.main.async { self.feedVC.updateView() }
                }
            }
        }
	}
    
    
    
    func showNews(index:Int){
        if index >= 0 && index < news.streams.count{
            self.feedVC.stream = news.streams[index]
        }
        feedVC.view.isHidden = false
        briefVC.view.isHidden = true
    }
    func showBrief(){
        feedVC.view.isHidden = true
        briefVC.view.isHidden = false
    }
    
    

}
extension FeedTabViewController:SwitchSelectorDelegate {
    func didSelect(_ index: Int) {
        if index > 0 {
            showNews(index: index - 1)
        }else{
            showBrief()
        }
        
    }
}

