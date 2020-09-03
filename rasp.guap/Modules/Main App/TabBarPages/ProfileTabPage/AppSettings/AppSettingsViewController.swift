//
//  AppSettingsViewController.swift
//  rasp.guap
//
//  Created by Кирилл on 03.09.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit
import MBRadioButton


class AppSettingsViewController: ViewController<AppSettingsView> {
	
	let startScreens:[String] = [
		"Новости",
		"Дедлайны",
		"Расписание",
		"Настройки"
	]
	let buildings:[String] = [
		"Новости",
		"Дедлайны",
		"Расписание",
		"Настройки"
	]

	let screensRadioContainer = MBRadioButtonContainer([])
	let buildingsRadioContainer = MBRadioButtonContainer([])

	
	override func viewDidLoad() {
		self.keyboardReflective = false
		setupStartScreens()
		setupBuildingList()
	}
	
	func setupStartScreens(){
		let buttons = self.startScreens.enumerated().map{ (offset,title) -> MBRadioButton in
			let button = MBRadioButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
			button.tag = offset
			button.setTitle(title, for: .normal)
			button.setTitleColor(Asset.PocketColors.pocketGray.color, for: .normal)
			button.titleLabel?.font = FontFamily.SFProDisplay.regular.font(size: 14)
			self.rootView.startScreenSelector.addArrangedSubview(button)
			button.snp.makeConstraints { $0.height.equalTo(30)}
			return button
		}
		screensRadioContainer.addButtons(buttons)
		screensRadioContainer.delegate = self
	}
	
	func setupBuildingList(){
		let buttons = self.buildings.enumerated().map{ (offset,title) -> MBRadioButton in
			let button = MBRadioButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
			button.tag = offset
			button.setTitle(title, for: .normal)
			button.setTitleColor(Asset.PocketColors.pocketGray.color, for: .normal)
			button.titleLabel?.font = FontFamily.SFProDisplay.regular.font(size: 14)
			self.rootView.buildingSelector.addArrangedSubview(button)
//			button.snp.makeConstraints { $0.height.equalTo(30)}
			return button
		}
		buildingsRadioContainer.addButtons(buttons)
		buildingsRadioContainer.delegate = self
	}
}
extension AppSettingsViewController:MBRadioButtonDelegate{
	func radioButtonDidSelect(_ button: MBRadioButton) {
		
	}
	
	func radioButtonDidDeselect(_ button: MBRadioButton) {
		
	}
	
	
}

