//
//  MainTabBarController.swift
//  rasp.guap
//
//  Created by Кирилл on 12.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit
import SUAI_API
import ESTabBarController_swift

class MainTabBarController : ESTabBarController{
    init(){
        super.init(nibName: nil, bundle: nil)
        self.viewControllers = [
            FeedTabViewController(),
            DeadlinesTabViewController(),
            ScheduleTabViewController(),
            InfoTabViewController(),
            ProfileTabViewController()
        ]
        
		let userSetting = SAUserSettings.shared
        let startPage = userSetting.idtab
        self.selectedIndex = startPage - 1
    }
	
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.layer.cornerRadius = 10
        self.tabBar.layer.masksToBounds = true
        self.tabBar.barTintColor = Asset.PocketColors.pocketWhite.color
        self.tabBar.layer.shadowColor = Asset.PocketColors.pocketShadow.color.cgColor
        self.tabBar.layer.shadowRadius = 10
        self.tabBar.layer.shadowOffset = .zero
		
		self.view.addSubview(self.snackContainer)
		snackContainer.snp.makeConstraints { (make) in
			make.left.equalToSuperview().offset(10)
			make.right.equalToSuperview().inset(10)
			make.bottom.equalTo(self.tabBar.snp.top).offset(-15)
		}
		snackContainer.addTarget(action: {_ in
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {self.hideSnack()})
		}, for: .touchUpInside)
		hideSnack(animated: false)
    }

	
	let snack = PocketSnackView()
	lazy var snackBarDiv = PocketDivView(content: self.snack)
	lazy var snackContainer = PocketScalableContainer(content: self.snackBarDiv)
	
	func showSnack(animated:Bool = true){
		self.view.bringSubviewToFront(self.tabBar)
		UIView.animate(withDuration: animated ? 0.3 : 0) {
			self.snackContainer.transform = .identity
		}
		DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
			self.hideSnack()
		}
	}
	func hideSnack(animated:Bool = true){
		let offset = self.view.frame.height-snackBarDiv.frame.origin.y
		UIView.animate(withDuration:  animated ? 0.3 : 0) {
			self.snackContainer.transform = .init(translationX: 0, y: offset)
		}
	}
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
