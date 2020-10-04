//
//  AboutUsViewController.swift
//  rasp.guap
//
//  Created by Кирилл on 04.10.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

//AppIconLight

import UIKit

class AboutUsViewController:ViewController<AboutUsView>{
	override func viewDidLoad() {
		super.viewDidLoad()

		updateViewImage()
		
		self.rootView.imageContainer.addTarget(action: { (_) in
			if UIApplication.shared.supportsAlternateIcons {
				Logger.print("Supports alternate icons")
				self.switchIcon()
			}else{
				Logger.print("Not supports alternate icon")
			}
		}, for: .touchUpInside)
	}
	
	func updateViewImage(){
		if UIApplication.shared.supportsAlternateIcons{
			let iconName = UIApplication.shared.alternateIconName ?? "AppIconLight"
			UIView.animate(withDuration: 0.3) {
				self.rootView.image.image = UIImage(named: iconName)
			}
			
		}
	}
	
	func switchIcon(){
		if UIApplication.shared.alternateIconName == nil {
			UIApplication.shared.setAlternateIconName("DarkLogo") { (err) in
				Logger.print(err)
				self.updateViewImage()
			}
		}else{
			UIApplication.shared.setAlternateIconName(nil) { (err) in
				Logger.print(err)
				self.updateViewImage()
			}
		}
	}
}
