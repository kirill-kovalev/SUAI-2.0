//
//  SuaiIDViewController.swift
//  rasp.guap
//
//  Created by Кирилл on 03.09.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit
import SUAI_API

class SuaiIDViewController: ViewController<SuaiIDView> {
	override func viewDidLoad() {
		self.keyboardReflective = false
		
		self.rootView.submitBtn.addTarget(action: { (sender) in
			SAUserSettings.shared.prologin = self.rootView.emailTF.text
			SAUserSettings.shared.propass = self.rootView.passTF.text
			
			
			
			DispatchQueue.global().async {
				if SAUserSettings.shared.update() {
					print("SUAI ID OK")
				}else{
					print("SUAI ID Err")
				}
			}
		}, for: .touchUpInside)
		self.rootView.emailTF.addTarget(self, action: #selector(self.textFieldDidChange), for: .editingChanged)
		self.rootView.passTF.addTarget(self, action: #selector(self.textFieldDidChange), for: .editingChanged)
		
		
		DispatchQueue.global().async {
			self.update()
		}
	}
	@objc func textFieldDidChange(){
		self.rootView.submitBtn.isActive = !(self.rootView.emailTF.text?.isEmpty ?? true) && !(self.rootView.passTF.text?.isEmpty ?? true)
	}
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		DispatchQueue.global().async {
			SAUserSettings.shared.reload()
			self.update()
		}
	}
	
	func update(){
		let login = SAUserSettings.shared.prologin
		let pass = SAUserSettings.shared.propass
		DispatchQueue.main.async {
			self.rootView.emailTF.text = login
			self.rootView.passTF.text = pass
		}
	}
	
}
