//
//  MainTabBarController.swift
//  rasp.guap
//
//  Created by Кирилл on 12.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit
import ESTabBarController_swift

class MainTabBarController : ESTabBarController{
    init(){
        super.init(nibName: nil, bundle: nil)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.layer.cornerRadius = 10
        self.tabBar.layer.masksToBounds = true
        self.tabBar.barTintColor = Asset.PocketColors.pocketWhite.color
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
