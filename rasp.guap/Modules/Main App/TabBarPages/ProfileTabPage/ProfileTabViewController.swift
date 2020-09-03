//
//  FeedTabViewController.swift
//  rasp.guap
//
//  Created by Кирилл on 12.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit
import ESTabBarController_swift
import SwiftyVK

class ProfileTabViewController: ViewController<ProfileTabView> {
	required init() {
		super.init()
		self.tabBarItem = ESTabBarItem(PocketTabBarIcon(),title: "Настройки", image: Asset.AppImages.TabBarImages.profile.image, tag: 4)
		self.rootView.setTitle(self.tabBarItem.title ?? "")
	}
	required init?(coder: NSCoder) {fatalError()}
	
	override func viewDidLoad(){
		#if DEBUG
		setupLogoutButton()
		#endif
		
	}
	
	
	func setupLogoutButton(){
		let logoutButton = Button(frame: .zero)
		logoutButton.setTitle("L/O", for: .normal)
		logoutButton.setTitleColor(Asset.PocketColors.pocketBlack.color, for: .normal)
		self.rootView.addHeaderButton(logoutButton)
		logoutButton.addTarget(action: { (sender) in
			print("logout")
			VK.sessions.default.logOut()
			let vkVC = UINib(nibName: "VkLogin", bundle: nil).instantiate(withOwner: nil, options: nil).first as! VKLoginPageViewController
			vkVC.modalPresentationStyle = .fullScreen
			vkVC.modalTransitionStyle = .flipHorizontal
			self.present(vkVC, animated: true, completion: nil)
		}, for: .touchUpInside)
		self.rootView.title.snp.makeConstraints { (make) in
			make.bottom.equalToSuperview()
		}
	}
	
}
