//
//  StartScreenViewController.swift
//  rasp.guap
//
//  Created by Кирилл on 31.07.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit

class StartScreenViewController: ViewController<StartScreenView> {
    override func viewDidLoad() {
        self.rootView.pagedView.add(asChild: FirstScreenViewController(), of: self)
    }
    override func viewWillAppear(_ animated: Bool) {
//        UIView.animate(withDuration: 0.35) {
//            self.navigationController?.isNavigationBarHidden = false
//        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UIView.animate(withDuration: 0.35) {
            self.navigationController?.isNavigationBarHidden = true
        }
        
    }
}


