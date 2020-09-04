//
//  GroupSelectPageViewController.swift
//  rasp.guap
//
//  Created by Кирилл on 06.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit
import SUAI_API


class GroupSelectPageViewController : ViewController<GroupSelectPageView>,UserChangeDelegate {
    func didSetUser(user: SAUsers.User) {
		self.rootView.select.text = user.Name
		self.rootView.button.isActive = true
    }
    
    
    // MARK: - ViewController lifecycle
    override func viewDidLoad() {
		self.keyboardReflective = false
		self.rootView.select.delegate = self
        
        self.rootView.button.addTarget(action: { (b) in
            let user = self.rootView.select.text ?? ""
            if SASchedule.shared.groups.get(name: user) != nil {
                SAUserSettings.shared?.group = user
                
                if((SAUserSettings.shared?.update()) ?? false){
                    let _ = UIApplication.shared.appDelegate.application(UIApplication.shared, didFinishLaunchingWithOptions: nil)
				}else{
					print("error while setting group")
				}
                
            }
        }, for: .touchUpInside)
    }
    
    // MARK: - Actions
    
    
}

extension GroupSelectPageViewController : UITextFieldDelegate{
	
    func textFieldDidBeginEditing(_ textField: UITextField) {
		textField.resignFirstResponder()
		let vc = TimetableFilterViewConroller()
		vc.hidePreps()
		vc.delegate = self
		self.present(vc, animated: true)
	}

}
