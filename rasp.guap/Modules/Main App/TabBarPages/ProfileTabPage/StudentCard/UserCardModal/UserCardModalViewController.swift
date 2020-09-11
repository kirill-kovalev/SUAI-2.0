//
//  UserCardModalViewController.swift
//  rasp.guap
//
//  Created by Кирилл on 09.09.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit
import CoreMotion
import SwiftyVK
import SUAI_API

class UserCardModalViewController: ModalViewController<UserCardModalView> {
	let motionManager = CMMotionManager()
	
	override func viewDidLoad() {
		
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
				self.content.card.groupLabel.text = group
				self.content.card.userLabel.text = "\(resp.first_name) \(resp.last_name)"
			}
			
			NetworkManager.dataTask(url: resp.photo_100) { (result) in
				switch result{
					case .success(let data):
						guard let image = UIImage(data: data) else {break}
						DispatchQueue.main.async {self.content.card.profileImage.image = image }
					break;
					case .failure: break;
				}
			}
		}
		
		self.content.serviceStack.addArrangedSubview(PocketServiceListItem("SUAI Pocket", true))
		self.content.serviceStack.addArrangedSubview(PocketServiceListItem("SUAI Bot", true))
		self.content.serviceStack.addArrangedSubview(PocketServiceListItem("pro.guap", false))
		self.content.serviceStack.addArrangedSubview(PocketServiceListItem("SUAI Pocket Android", false))
		self.content.serviceStack.addArrangedSubview(PocketServiceListItem("SUAI Pocket iOS", true))
		
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		var start:CMDeviceMotion?

		motionManager.deviceMotionUpdateInterval = 1/60
		motionManager.startDeviceMotionUpdates(to: OperationQueue.main) { (motion, error) in
			start = start ?? motion
			guard let new = motion?.gravity else { print("new failed"); return}
			guard let old = start?.gravity else { print("old failed"); return}
			let diff = CMAcceleration(x: new.x-old.x, y: new.y-old.y, z: new.z-old.z)
			let angle = Double(30.degreesToRadians)
			self.rotateCard(x: diff.x*angle, y: diff.y*angle, z: diff.z*angle)
		}
		
	}
	func rotateCard(x:Double,y:Double,z:Double){
		let rotX = CATransform3DRotate(CATransform3DIdentity, CGFloat(x)*0.3, 0, 0, -1)
		let rotXY = CATransform3DRotate(rotX, CGFloat(y), -1, 0, 0)
		let rotXYZ = CATransform3DRotate(rotXY, CGFloat(z), 0, 0, 0)
		
		self.content.card.layer.transform = rotXYZ
	}
}
