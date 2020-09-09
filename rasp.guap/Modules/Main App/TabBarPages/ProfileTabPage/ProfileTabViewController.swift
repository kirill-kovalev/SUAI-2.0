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
	
	let studentCard = StudentCardViewController()
	let suaiID = SuaiIDViewController()
	let settings = AppSettingsViewController()
	override func viewDidLoad(){
		self.keyboardReflective = false
		
		setupLogoutButton()
		
		
		self.addBlock(title: "Карточка студента", vc:studentCard)
		self.addBlock(title: "SUAI ID", vc: suaiID)
		self.addBlock(title: "Основные настройки", vc: settings)
		//self.addBlock(title: "О сервисе", view: nil)
	}
	func addBlock(title:String,vc:UIViewController) {
		self.addChild(vc)
		self.rootView.addBlock(title: title, view: PocketDivView(content: vc.view))
		vc.didMove(toParent: self)
	}
	
	
	func setupLogoutButton(){
		let logoutButton = Button(frame: .zero)
		logoutButton.setImage(Asset.AppImages.logout.image.withRenderingMode(.alwaysTemplate), for: .normal)
		logoutButton.imageView?.tintColor = Asset.PocketColors.pocketDarkBlue.color
		logoutButton.transform = CGAffineTransform(rotationAngle: 180.degreesToRadians)
		logoutButton.imageView!.snp.makeConstraints{$0.size.equalTo(CGSize(width: 24, height: 24))}
		
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
