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
		
		
    }
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		showSnack(status: .ok, text: "alert")
	}

	
	
	
	func showSnack(status:PocketSnackView.Status,text:String){
		let snack = PocketSnackView(status: status, text: text)
		let snackBarDiv = PocketDivView(content: snack)
		let snackContainer = PocketScalableContainer(content: snackBarDiv)
		
		self.view.addSubview(snackContainer)
		self.view.bringSubviewToFront(self.tabBar)
		
		snackContainer.snp.makeConstraints { (make) in
			make.left.equalToSuperview().offset(10)
			make.right.equalToSuperview().inset(10)
			make.bottom.equalTo(self.tabBar.snp.top).offset(-15)
		}
		snackContainer.addTarget(action: {_ in
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
				self.hideSnack(snackContainer)
			})
		}, for: .touchUpInside)
		
		let offset = self.view.frame.height-snack.frame.origin.y
		snackContainer.transform = .init(translationX: 0, y: offset)
		UIView.animate(withDuration: 0.3) {
			snackContainer.transform = .identity
		}
		DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
			self.hideSnack(snackContainer)
		}
	}
	
	func hideSnack(_ snack:UIView){
		let offset = self.view.frame.height-snack.frame.origin.y
		UIView.animate(withDuration: 0.3, animations: {
			snack.transform = .init(translationX: 0, y: offset)
		}) { (ended) in
			snack.removeFromSuperview()
		}
	}
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
