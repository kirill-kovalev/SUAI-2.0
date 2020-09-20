//
//  StudentCardViewController.swift
//  rasp.guap
//
//  Created by Кирилл on 03.09.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit
import SUAI_API
import SwiftyVK

class StudentCardViewController: ViewController<StudentCardView> {
	override func viewDidLoad() {
		super.viewDidLoad()
		self.keyboardReflective = false
		loadData()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		DispatchQueue.global().async {
			if !SAUserSettings.shared.reload(){
				MainTabBarController.Snack(status: .err, text: "Не удалось загрузить информацию о пользователе")
			}
			self.loadData()
		}
	}
	
	func loadData(){

		DispatchQueue.global().async {
			let settings = SAUserSettings.shared
			
			if let group = settings.group,
				let name = settings.vkName,
				let photoUrl = settings.vkPhoto{
				
				
				DispatchQueue.main.async {
					self.rootView.group.text = "Группа "+(group)
					self.rootView.name.text = "\(name)"
				}
				
				NetworkManager.dataTask(url: photoUrl) { (result) in
					switch result{
						case .success(let data):
							guard let image = UIImage(data: data) else {break}
							DispatchQueue.main.async { self.rootView.avatar.imageView.image = image }
						break;
						case .failure: break;
					}
				}
				
				
			}
			
		}
	}
}
