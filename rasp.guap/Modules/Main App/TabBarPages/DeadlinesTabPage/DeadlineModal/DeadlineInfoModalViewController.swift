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
    
    init(deadline:SADeadline?=nil) {
        self.deadline = deadline ?? SADeadline()
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
        
        self.content.commentLabel.text = deadline.comment
        self.content.nameLabel.text = deadline.deadline_name
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "RU")
        formatter.dateFormat = "dd MMMM"
        self.content.dateLabel.text = formatter.string(from: deadline.end)
        
        
        
        self.content.lessonSectionTitle.isHidden = true
        self.content.lessonLabel.isHidden = true
        
        
        if deadline.subject_name  != nil {
                self.content.lessonSectionTitle.isHidden = false
                self.content.lessonLabel.isHidden = false

            self.content.lessonLabel.text = deadline.subject_name!
            
            
        }
    }
    
    
}
