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
            make.top.left.right.equalToSuperview()
			make.bottom.equalTo(self.rootView.safeAreaLayoutGuide)
        }
        feedVC.didMove(toParent: self)
        return feedVC
    }()
    
    lazy var briefVC:FeedBriefInfoViewController = {
        let briefVC = FeedBriefInfoViewController()
        self.addChild(briefVC)
        self.rootView.addSubview(briefVC.view)
        briefVC.view.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
			make.bottom.equalTo(self.rootView.safeAreaLayoutGuide)
        }
        briefVC.didMove(toParent: self)
        return briefVC
    }()
	
	required init() {
		super.init()
		let tabImage = Asset.AppImages.TabBarImages.feed.image
        self.tabBarItem = ESTabBarItem(PocketTabBarIcon(),title:"Новости", image: tabImage , tag: 0)
		self.tabBarItem.image?.accessibilityValue = Asset.AppImages.TabBarImages.feed.name
	}
	
	required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
	
    override func viewDidLoad() {
		super.viewDidLoad()
        self.rootView.setTitle(self.tabBarItem.title ?? "")
        

        self.rootView.sourceSelector.switchDelegate = self
		
        
        showBrief()
		showSources()
		let gesture = UIPanGestureRecognizer(target: self, action: #selector(self.swipePages(_:)) )
		self.rootView.addGestureRecognizer(gesture)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
		self.rootView.sourceSelector.updateView()
		if news.sources.count == 0 {
			reloadSources()
		}else if news.sources.count != (SANews.shared.sources.count + 1){
			showSources()
		}
		
    }
	@objc func swipePages(_ sender :UIPanGestureRecognizer){
		
		let index = self.rootView.sourceSelector.selectedIndex
		let translation = sender.translation(in: self.rootView)
		if sender.state == .ended,
		   abs(translation.x)/2 > abs(translation.y){
			if (translation.x > self.rootView.bounds.width/2 || sender.velocity(in: self.rootView).x > 25){
				if ( index == 0){UINotificationFeedbackGenerator().notificationOccurred(.error);return}
				self.rootView.sourceSelector.selectedIndex -= 1
				self.didSelect(self.rootView.sourceSelector.selectedIndex)

			} else if (translation.x < -self.rootView.bounds.width/2 || sender.velocity(in: self.rootView).x < -25){
				if (index == self.rootView.sourceSelector.count-1){UINotificationFeedbackGenerator().notificationOccurred(.error);return}
					self.rootView.sourceSelector.selectedIndex += 1
					self.didSelect(self.rootView.sourceSelector.selectedIndex)
			}
			
		}
		
	}
	
	
	
	func reloadSources(){
		DispatchQueue.global().async {
			
			if SANews.shared.loadSourceList(){
				DispatchQueue.main.async {
					
					self.rootView.sourceSelector.updateView()
					self.showSources()
				}
			}else{
				MainTabBarController.Snack(status: .err, text: "Не удалось загрузить список источников")
			}
			
		}
	}
	func showSources(){
		self.rootView.sourceSelector.clear()
		self.rootView.sourceSelector.layoutIfNeeded()
		self.rootView.sourceSelector.add(SwitchSelectorButton(title: "Сводка", titleColor: Asset.PocketColors.pocketGray.color, selectedTitleColor: Asset.PocketColors.buttonOutlineBorder.color, backgroundColor: Asset.PocketColors.pocketBlue.color))
		for s in self.news.sources{
			let btn = SwitchSelectorButton(title: s.name, titleColor: Asset.PocketColors.pocketGray.color, selectedTitleColor: Asset.PocketColors.buttonOutlineBorder.color, backgroundColor: Asset.PocketColors.pocketBlue.color)
			self.rootView.sourceSelector.add(btn)
		}
		self.rootView.sourceSelector.setNeedsLayout()
		self.rootView.sourceSelector.layoutIfNeeded()
		self.rootView.sourceSelector.updateView()
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

extension FeedTabViewController:UIGestureRecognizerDelegate{}
