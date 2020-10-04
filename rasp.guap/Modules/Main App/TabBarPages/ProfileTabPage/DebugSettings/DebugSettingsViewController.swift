//
//  DebugSettingsViewController.swift
//  rasp.guap
//
//  Created by Кирилл on 04.10.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit

class DebugSettingsViewController: UIViewController {
	let rootView = DebugSettingsView()
	override func loadView() {
		self.view = rootView
	}
	override func viewDidLoad() {
		self.rootView.textField.text = Logger.log
	}
}
