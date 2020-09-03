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
		
		struct vkResponse:Codable{
            let last_name: String
            let first_name: String
			let photo_100:String
        }
		
		DispatchQueue.global().async {
			guard let settings = SAUserSettings.shared,
				  let group = settings.group,
				  let vkData = try? VK.API.Users.get([.fields:"photo_100"]).synchronously().send(),
				  let resp = try? JSONDecoder().decode([vkResponse].self, from: vkData).first
			else {return}
			DispatchQueue.main.async {
				self.rootView.group.text = "Группа "+group
				self.rootView.name.text = "\(resp.first_name) \(resp.last_name)"
			}
			NetworkManager.dataTask(url: resp.photo_100) { (result) in
				switch result{
					case .success(let data):
						guard let image = UIImage(data: data) else {break}
						self.rootView.avatar.imageView.image = image
					break;
					case .failure: break;
				}
			}
		}
		
	}
}
