//
//  DebugSettingsViewController.swift
//  rasp.guap
//
//  Created by Кирилл on 04.10.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit

class DebugSettingsViewController: ModalViewController <DebugSettingsView> {

	override func viewDidLoad() {
//		self.rootView.textField.text = Logger.log
		self.content.textField.text = Logger.log
		self.content.oldimetable.toggle.isOn = AppSettings.isOldTimetableEnabled
		self.content.oldimetable.toggle.addTarget(self, action: #selector(self.setOldTimetable), for: .valueChanged)
	}
	@objc private func setOldTimetable(){
		AppSettings.isOldTimetableEnabled = self.content.oldimetable.toggle.isOn
		Logger.print(from: "", "ВСЕ ОК, отчеты отклоню, оно не вылетает, а закрывается")
		//exit(0)
	}
}
