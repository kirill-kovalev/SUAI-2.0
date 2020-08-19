//
//  DeadlineInfoModalViewController.swift
//  rasp.guap
//
//  Created by Кирилл on 19.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit
import SUAI_API

class DeadlineInfoModalViewController : ModalViewController<DeadlineInfoModalView>{
    
    var deadline:SADeadline
    
    init(lesson:SADeadline?=nil) {
        self.deadline = lesson ?? SADeadline()
        super.init()
    }
    
    required init() {
        self.deadline = SADeadline()
        super.init()
    }
    required init?(coder: NSCoder) {
        self.deadline = SADeadline()
        super.init(coder:coder)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.rootView.titleLabel.text = "Карточка Дедлайна"
        

    }
    
    
}
