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
	
		var start:CMAttitude? = nil
		motionManager.deviceMotionUpdateInterval = 1/4
		motionManager.startDeviceMotionUpdates(to: OperationQueue.main) { (motion, error) in
			guard let new = motion?.attitude else {return}
			start = start ?? new
			
			let pitch = (new.pitch - start!.pitch)
			let roll = new.roll - start!.roll
			let yaw = new.yaw - start!.yaw
			
			let coef_p = (pitch<0.8 && pitch > -0.5) ? 0.8 : 0.7
			UIView.animateKeyframes(withDuration: self.motionManager.deviceMotionUpdateInterval, delay: 0, options: [.beginFromCurrentState], animations: {
				self.rotateCard(x:pitch*coef_p, y:roll*0.12, z:yaw*0.12)
			}, completion: nil)
			
		}
		
	}
	func rotateCard(x:Double,y:Double,z:Double){
		let rotX = CATransform3DRotate(CATransform3DIdentity, CGFloat(x),-1, 0, 0)
		let rotXY = CATransform3DRotate(rotX, CGFloat(y), 0, -1, 0)
		let rotXYZ = CATransform3DRotate(rotXY, CGFloat(z), 0, 0, 1)
		
		self.content.card.layer.transform = rotXYZ
	}
}
