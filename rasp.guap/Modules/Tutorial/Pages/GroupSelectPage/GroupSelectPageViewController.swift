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
        
		self.rootView.button.addTarget(self, action: #selector(self.groupSelected), for: .touchUpInside)
    }
    
    // MARK: - Actions
	@objc private func groupSelected(){
		let user = self.rootView.select.text ?? ""
		self.rootView.button.disable()
		
		DispatchQueue.global().async {
			if SASchedule.shared.groups.get(name: user) != nil {
				SAUserSettings.shared.group = user
				if SAUserSettings.shared.update() {
					DispatchQueue.main.async {
						self.rootView.button.enable()
						self.present(DataLoaderViewController(), animated: true, completion: nil)
					}

				}else{
					DispatchQueue.main.async {
						self.rootView.button.enable()
					}
					Logger.print(from: #function, "error while setting group")
				}

			}
		}
		
	}
    
}

extension GroupSelectPageViewController : UITextFieldDelegate{
	
    func textFieldDidBeginEditing(_ textField: UITextField) {
		textField.resignFirstResponder()
		let vc = TimetableFilterViewConroller()
		vc.filterTypes = .groups
		vc.delegate = self
		self.present(vc, animated: true)
	}

}
