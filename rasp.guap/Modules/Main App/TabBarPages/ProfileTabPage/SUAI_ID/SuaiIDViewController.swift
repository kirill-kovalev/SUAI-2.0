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
		
		self.rootView.submitBtn.addTarget(action: { (_) in
			SAUserSettings.shared.prologin = self.rootView.emailTF.text
			SAUserSettings.shared.propass = self.rootView.passTF.text
			
			self.rootView.submitBtn.isActive = false
			DispatchQueue.global().async {
				if SAUserSettings.shared.update() {
					_ = ProGuap.shared.auth(login: SAUserSettings.shared.prologin ?? "", pass: SAUserSettings.shared.propass ?? "")
					Logger.print(from: #function, "SUAI ID OK")
					MainTabBarController.Snack(status: .ok, text: "Аккаунт привязан")
					DispatchQueue.main.async {self.rootView.submitBtn.isActive = false}
					self.isTextEdited = false
				} else {
					Logger.print(from: #function, "SUAI ID Err")
					MainTabBarController.Snack(status: .err, text: "Ошибка авторизации в pro.guap")
					DispatchQueue.main.async {self.textFieldDidChange()}
				}
			}
		}, for: .touchUpInside)
		self.rootView.emailTF.addTarget(self, action: #selector(self.textFieldDidChange), for: .editingChanged)
		self.rootView.passTF.addTarget(self, action: #selector(self.textFieldDidChange), for: .editingChanged)
		
		DispatchQueue.global().async {
			self.update()
		}
	}
	var isTextEdited = false
	@objc func textFieldDidChange() {
		self.isTextEdited = true
		self.rootView.submitBtn.isActive = !(self.rootView.emailTF.text?.isEmpty ?? true) && !(self.rootView.passTF.text?.isEmpty ?? true)
	}
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		DispatchQueue.global().async {
			if !self.isTextEdited,
				SAUserSettings.shared.reload() {
				self.update()
			}
		}
	}
	
	func update() {
		guard !isTextEdited else {return}
		let login = SAUserSettings.shared.prologin
		let pass = SAUserSettings.shared.propass
		DispatchQueue.main.async {
			self.rootView.emailTF.text = login
			self.rootView.passTF.text = pass
		}
		
		if let login = login,
		   let pass = pass,
		   ProGuap.shared.auth(login: login, pass: pass) {
			DispatchQueue.main.async {
				self.rootView.emailTF.text = login
				self.rootView.passTF.text = pass
			}
			self.isTextEdited = false
		}
		
	}
	
}
