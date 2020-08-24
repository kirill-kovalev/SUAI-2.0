//
//  DeadlineEditModalViewController.swift
//  rasp.guap
//
//  Created by Кирилл on 24.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit
import SUAI_API

class DeadlineEditModalViewControllerPrototype : ModalViewController<DeadlineEditModalView>{
    
    var deadline:SADeadline?
    
    var onChange:(()->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        
        self.content.closeButton.addTarget(action: { (sender) in
            
        }, for: .touchUpInside)
        
    }
    
    
}

