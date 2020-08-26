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
        self.rootView.select.setTitle(user.Name, for: .normal)
        
        
    }
    
    
    // MARK: - ViewController lifecycle
    override func viewDidLoad() {
        self.rootView.select.addTarget(action: { (sender) in
            let vc = TimetableFilterViewConroller()
            vc.delegate = self
            self.present(vc, animated: true, completion: nil)
        }, for: .touchUpInside)
        
        self.rootView.button.addTarget(action: { (b) in
            let user = self.rootView.select.titleLabel?.text ?? ""
            if SASchedule.shared.groups.get(name: user) != nil {
                SAUserSettings.shared?.group = user
                print(SAUserSettings.shared?.update())
                
                UIApplication.shared.appDelegate.application(UIApplication.shared, didFinishLaunchingWithOptions: nil)
            }
        }, for: .touchUpInside)
    }
    
    // MARK: - Actions
    
    
}
