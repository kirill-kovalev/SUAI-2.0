//
//  VKLoginPage.swift
//  rasp.guap
//
//  Created by Кирилл on 19.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit
import SUAI_API
import SwiftyVK

class VKLoginPageViewController: UIViewController {
    
	@IBOutlet weak var LoginButton: UIButton!
	@IBOutlet weak var errLabel: UILabel!
    @IBAction func loginViaVK(_ sender: UIButton, forEvent event: UIEvent) {
        VK.sessions.default.logIn(onSuccess: { _ in
            PocketAPI.shared.setToken(VK.sessions.default.accessToken!.get()!)
            DispatchQueue.main.async {
                let _ = UIApplication.shared.appDelegate.application(UIApplication.shared, didFinishLaunchingWithOptions: nil)
            }
        }) { (err) in
            DispatchQueue.main.async {
                self.errLabel.text = err.localizedDescription
                self.errLabel.isHidden = false
            }
            
            print(err)
        }
    }
	override func viewDidLoad() {
		super.viewDidLoad()
		let color = Asset.PocketColors.pocketDarkBlue.color
		self.LoginButton.layer.borderWidth = 2
		self.LoginButton.layer.borderColor = color.cgColor
		self.LoginButton.setTitleColor(color, for: .normal)
		self.LoginButton.setImage(Asset.SystemIcons.vkLogo.image.withRenderingMode(.alwaysTemplate), for: .normal)
		self.LoginButton.imageView?.tintColor = color
		
		self.LoginButton.titleLabel?.snp.makeConstraints({ (make) in
			make.centerY.equalToSuperview()
			make.centerX.equalToSuperview().offset(6)
		})
		
	}
	override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		super.traitCollectionDidChange(previousTraitCollection)
		self.LoginButton.layer.borderColor = self.LoginButton.titleLabel?.textColor.cgColor
	}
    override func viewDidAppear(_ animated: Bool){
		self.LoginButton.imageView?.snp.makeConstraints({ (make) in
			make.width.height.equalTo(22)
			make.right.equalTo(self.LoginButton.titleLabel!.snp.left).offset(-5)
		})
		
        VK.release()
        VK.setUp(appId: "7578765", delegate: self)
		VK.sessions.default.logOut()
    }
}
extension VKLoginPageViewController:SwiftyVKDelegate{
    func vkNeedToPresent(viewController: VKViewController) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    func vkNeedsScopes(for sessionId: String) -> Scopes { [.offline,.stats] }
    
    
}
