//
//  AppSettingsViewController.swift
//  rasp.guap
//
//  Created by Кирилл on 03.09.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit
import MBRadioButton
import SUAI_API


class AppSettingsViewController: ViewController<AppSettingsView> {
	

	// MARK: - Список табов
	let startScreens:[String] = [
		"Новости",
		"Дедлайны",
		"Расписание",
		"Справочник"
	]
	// MARK: - Список зданий
	let buildings:[String] = [
		"Большая морская 67",
		"Гастелло 15",
		"Ленсовета 14"
	]
	
	
	let screensRadioContainer = MBRadioButtonContainer([])
	let buildingsRadioContainer = MBRadioButtonContainer([])
	
	// MARK: - создание radioButton
	func createRadioButton(title:String)->MBRadioButton{
		let button = MBRadioButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
		button.setTitle(title, for: .normal)

		button.setTitleColor(Asset.PocketColors.pocketGray.color, for: .normal)
		button.titleLabel?.font = FontFamily.SFProDisplay.semibold.font(size: 14)
		
		
		let color = Asset.PocketColors.pocketDarkBlue.color
		button.radioButtonColor = MBRadioButtonColor(active: color, inactive: color)
		button.radioCircle = MBRadioButtonCircleStyle(outerCircle: 20, innerCircle: 14, outerCircleBorder: 2,contentPadding: 12)
		
		
		button.snp.makeConstraints { $0.height.equalTo(30)}
		return button
	}
	
	func setupStartScreens(){
		let buttons = self.startScreens.enumerated().map{ (offset,title) -> MBRadioButton in
			let button = self.createRadioButton(title: title)
			button.tag = offset
			self.rootView.startScreenSelector.addArrangedSubview(button)
			return button
		}
		screensRadioContainer.addButtons(buttons)
		screensRadioContainer.delegate = self
	}
	
	func setupBuildingList(){
		let buttons = self.buildings.enumerated().map{ (offset,title) -> MBRadioButton in
			let button = self.createRadioButton(title: title)
			button.tag = -offset
			self.rootView.buildingSelector.addArrangedSubview(button)
			return button
		}
		buildingsRadioContainer.addButtons(buttons)
		buildingsRadioContainer.delegate = self
	}

	// MARK: - VС Lifecycle
	override func viewDidLoad() {
		self.keyboardReflective = false
		self.rootView.groupSelector.delegate = self
		setupStartScreens()
		setupBuildingList()
		update()
		self.rootView.groupSelector.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.groupSelectorTap)))
	}
	@objc private func groupSelectorTap(){
		let vc = TimetableFilterViewConroller()
		vc.filterTypes = .groups
		vc.delegate = self
		self.present(vc, animated: true)
	}
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		update()
	}
	
	// MARK: - content update from server
	func update(){
		DispatchQueue.global().async {
			if SAUserSettings.shared.reload() {
				self.updateView()
			}
		}
	}
	func updateView(){
		let idTab = SAUserSettings.shared.idtab  - 1
		let building = SAUserSettings.shared.building - 1
		let group = SAUserSettings.shared.group
			
		DispatchQueue.main.async {
			self.rootView.groupSelector.text = group
			if idTab >= 0 && idTab < self.screensRadioContainer.allButtons.count{
				self.screensRadioContainer.selectedButton = self.screensRadioContainer.allButtons[idTab]
			}
			if building >= 0 && building < self.buildingsRadioContainer.allButtons.count{
				self.buildingsRadioContainer.selectedButton = self.buildingsRadioContainer.allButtons[building]
			}
			
		}
	}
	
	
	func setGroup(name:String){
		DispatchQueue.global().async {
			let originGroup = SAUserSettings.shared.group
			SAUserSettings.shared.group = name
			if SAUserSettings.shared.update() {
				print("group set to \(name)")
				MainTabBarController.Snack(status: .ok, text: "Группа установлена")
			}else{
				SAUserSettings.shared.group = originGroup
				MainTabBarController.Snack(status: .err, text: "Ошибка обновления настроек")
				DispatchQueue.main.async {
					self.updateView()
				}
			}
			
		}
	}
	
	func setBuilding(_ id:Int){
		let id = id + 1
		DispatchQueue.global().async {
			let originBuilding = SAUserSettings.shared.building
			print("originBuilding : \(originBuilding)")
			print("new building : \(id)")
			if originBuilding != id {
				DispatchQueue.main.async{
					self.rootView.isUserInteractionEnabled = false
					self.rootView.layer.opacity = 0.5
				}
				
				SAUserSettings.shared.building = id
				if (SAUserSettings.shared.update()){
					print("building set to \(id)")
					MainTabBarController.Snack(status: .ok, text: "Здание установлено")
				}else{
					SAUserSettings.shared.building = originBuilding
					MainTabBarController.Snack(status: .err, text: "Ошибка обновления настроек")
					self.updateView()
				}
				DispatchQueue.main.async{
					self.rootView.isUserInteractionEnabled = true
					self.rootView.layer.opacity = 1
				}
			}
		}
	}
	func setStartPage(_ id:Int){
		print("set tab : \(id)")
		let id = id + 1
		
		DispatchQueue.global().async {
			let originTab = SAUserSettings.shared.idtab
			print("origin tab : \(originTab)")
			print("new tab : \(id)")
			if originTab != id {
				DispatchQueue.main.async{
					self.rootView.isUserInteractionEnabled = false
					self.rootView.layer.opacity = 0.5
				}
				
				SAUserSettings.shared.idtab = id
				if (SAUserSettings.shared.update()){
					print("start page set to \(id)")
					MainTabBarController.Snack(status: .ok, text: "Начальная страница установлена")
				}else{
					print("update Error")
					MainTabBarController.Snack(status: .err, text: "Ошибка обновления настроек")
					SAUserSettings.shared.idtab = originTab
					self.updateView()
				}
				DispatchQueue.main.async{
					self.rootView.isUserInteractionEnabled = true
					self.rootView.layer.opacity = 1
				}
			}
			
		}
	}
	
	
}

extension AppSettingsViewController : UITextFieldDelegate{
	
    func textFieldDidBeginEditing(_ textField: UITextField) {
		
		textField.resignFirstResponder()
//		let vc = TimetableFilterViewConroller()
//		vc.filterTypes = .groups
//		vc.delegate = self
//		self.present(vc, animated: true) {
//			NotificationCenter.default.post(name: UIResponder.keyboardWillShowNotification, object: nil)
//		}
	}

}
extension AppSettingsViewController: UserChangeDelegate{
	func didSetUser(user: SAUsers.User) {
		self.rootView.groupSelector.text = user.Name
		self.setGroup(name:user.Name)
	}
	
	
}

extension AppSettingsViewController:MBRadioButtonDelegate{
	func radioButtonDidDeselect(_ button: MBRadioButton) { }
	
	
	func radioButtonDidSelect(_ button: MBRadioButton) {
		if button.tag >= 0 {
			self.setStartPage(button.tag)
		}else{
			self.setBuilding(-button.tag)
		}
	}

}
