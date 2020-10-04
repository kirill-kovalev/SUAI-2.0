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
import SUAI_API

class ProfileTabViewController: ViewController<ProfileTabView> {
	required init() {
		super.init()
		self.tabBarItem = ESTabBarItem(PocketTabBarIcon(),title: "Настройки", image: Asset.AppImages.TabBarImages.profile.image, tag: 4)
		self.rootView.setTitle(self.tabBarItem.title ?? "")
	}
	required init?(coder: NSCoder) {fatalError()}
	
	let studentCard = StudentCardViewController()
	let suaiID = SuaiIDViewController()
	let settings = ServiceSettingsViewController()
	let appSettings = AppSettingsViewController()
	
	override func viewDidLoad(){
		self.keyboardReflective = false
		
		setupLogoutButton()
		
		
		
		let scalable = PocketScalableContainer(content: PocketDivView(content: studentCard.view))
		scalable.addTarget(action: {_ in
			let vc = UserCardModalViewController()
			vc.content.card.profileImage.image = self.studentCard.rootView.avatar.imageView.image
			vc.content.card.userLabel.text = self.studentCard.rootView.name.text
			self.present(vc, animated: true, completion: nil)
		}, for: .touchUpInside)
		self.addChild(studentCard)
		self.rootView.addBlock(title: "Карточка студента", view: scalable)
		studentCard.didMove(toParent: self)
		

		self.addBlock(title: "SUAI ID", vc: suaiID)
		self.addBlock(title: "Основные настройки", vc: settings)
		self.addBlock(title: "Настройки приложения", vc: appSettings)
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
			
			
			if self.studentCard.rootView.name.text?.contains("Лола") ?? false {
				let alert = UIAlertController(title: "Скоро рассвет", message: "Выхода нет", preferredStyle: .alert)
				alert.addAction(UIAlertAction(title: "и полетели", style: .destructive, handler: { _ in self.logout()}))
				alert.addAction(UIAlertAction(title: "Ключ поверни", style: .cancel, handler: { _ in alert.dismiss(animated: true, completion: nil) }))
				self.present(alert, animated: true, completion: nil)
			}else{
				let alert = UIAlertController(title: "Выйти?", message: "Это действие отменить нельзя.", preferredStyle: .alert)
				alert.addAction(UIAlertAction(title: "Выйти", style: .destructive, handler: { _ in self.logout()}))
				alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: { _ in alert.dismiss(animated: true, completion: nil) }))
				self.present(alert, animated: true, completion: nil)
			}
			
			
		}, for: .touchUpInside)
		self.rootView.title.snp.makeConstraints { (make) in
			make.bottom.equalToSuperview()
		}
	}
	
	private func logout(){
		Logger.print(from: #function, "logout")
		AppSettings.clearCache()
		SAUserSettings.shared.reset()
		DispatchQueue.global().async { VK.sessions.default.logOut() }
		let vkVC = UINib(nibName: "VkLogin", bundle: nil).instantiate(withOwner: nil, options: nil).first as! VKLoginPageViewController
		vkVC.modalPresentationStyle = .fullScreen
		vkVC.modalTransitionStyle = .flipHorizontal
		self.present(vkVC, animated: true, completion: nil)
	}
	
}
