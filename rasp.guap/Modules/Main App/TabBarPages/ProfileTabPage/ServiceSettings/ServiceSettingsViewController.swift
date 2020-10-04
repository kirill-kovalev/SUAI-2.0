//
//  ServiceSettingsViewController.swift
//  rasp.guap
//
//  Created by Кирилл on 03.09.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit
import MBRadioButton
import SUAI_API


class ServiceSettingsViewController: ViewController<ServiceSettingsView> {
	

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
			button.tag = -offset-1
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
	func startLoading(){
		DispatchQueue.main.async{
			self.rootView.isUserInteractionEnabled = false
			self.rootView.content.layer.opacity = 0.5
			self.rootView.loadingIndidcator.isHidden = false
			self.rootView.loadingIndidcator.startAnimating()
		}
	}
	func stopLoading(){
		DispatchQueue.main.async{
			self.rootView.isUserInteractionEnabled = true
			self.rootView.content.layer.opacity = 1
			self.rootView.loadingIndidcator.stopAnimating()
		}
	}
	
	
	func setGroup(name:String){
		DispatchQueue.global().async {
			
			self.startLoading()
			
			let originGroup = SAUserSettings.shared.group
			SAUserSettings.shared.group = name
			if let group = SASchedule.shared.groups.get(name: name),
			SAUserSettings.shared.update() {
				print("group set to \(name)")
				MainTabBarController.Snack(status: .ok, text: "Группа установлена")
				// - MARK: УВедомления расписания!!!!!
				if !SASchedule.shared.load(for: group).setupNotifications(){
					Logger.print(from: #function, "Ошибка обновления уведомлений расписания")
				}
			}else{
				SAUserSettings.shared.group = originGroup
				MainTabBarController.Snack(status: .err, text: "Ошибка обновления настроек")
				DispatchQueue.main.async {
					self.updateView()
				}
			}
			
			self.stopLoading()
			
		}
	}
	
	func setBuilding(_ id:Int){
		DispatchQueue.global().async {
			let originBuilding = SAUserSettings.shared.building
			Logger.print(from: #function, "originBuilding : \(originBuilding)")
			Logger.print(from: #function, "new building : \(id)")
			if originBuilding != id {
				self.startLoading()
				
				SAUserSettings.shared.building = id
				if (SAUserSettings.shared.update()){
					Logger.print(from: #function, "building set to \(id)")
					MainTabBarController.Snack(status: .ok, text: "Здание установлено")
				}else{
					SAUserSettings.shared.building = originBuilding
					MainTabBarController.Snack(status: .err, text: "Ошибка обновления настроек")
					self.updateView()
				}
				self.stopLoading()
			}
		}
	}
	func setStartPage(_ id:Int){
		Logger.print(from: #function, "set tab : \(id)")
		let id = id + 1
		
		DispatchQueue.global().async {
			let originTab = SAUserSettings.shared.idtab
			Logger.print(from: #function, "origin tab : \(originTab)")
			Logger.print(from: #function, "new tab : \(id)")
			if originTab != id {
				self.startLoading()
				
				SAUserSettings.shared.idtab = id
				if (SAUserSettings.shared.update()){
					Logger.print(from: #function, "start page set to \(id)")
					MainTabBarController.Snack(status: .ok, text: "Начальная страница установлена")
				}else{
					Logger.print(from: #function, "update Error")
					MainTabBarController.Snack(status: .err, text: "Ошибка обновления настроек")
					SAUserSettings.shared.idtab = originTab
					self.updateView()
				}
				
				self.stopLoading()
			}
			
		}
	}
	
	
}

extension ServiceSettingsViewController : UITextFieldDelegate{
	
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
extension ServiceSettingsViewController: UserChangeDelegate{
	func didSetUser(user: SAUsers.User) {
		self.rootView.groupSelector.text = user.Name
		self.setGroup(name:user.Name)
	}
	
	
}

extension ServiceSettingsViewController:MBRadioButtonDelegate{
	func radioButtonDidDeselect(_ button: MBRadioButton) { }
	
	
	func radioButtonDidSelect(_ button: MBRadioButton) {
		if button.tag >= 0 {
			self.setStartPage(button.tag)
		}else{
			self.setBuilding(-button.tag)
		}
	}

}
