//
//  GroupSelectPageViewController.swift
//  rasp.guap
//
//  Created by Кирилл on 06.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit
class GroupSelectPageViewController : ViewController<GroupSelectPageView> {
    
     // MARK: - ViewController lifecycle
    override func viewDidLoad() {
        self.rootView.button.addTarget(action: { (sender) in
            self.present(TimetableFilterViewConroller(), animated: true, completion: nil)
        }, for: .touchUpInside)
    }
    
     // MARK: - Actions
    

}
