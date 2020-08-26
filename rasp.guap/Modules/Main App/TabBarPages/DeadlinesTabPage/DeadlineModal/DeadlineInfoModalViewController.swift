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
    
    var onChange:(()->Void)?
    
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
        
        setupContent()
        
        
        
        self.content.closeButton.addTarget(action: { (sender) in
            if self.deadline.closed == 0{
                let _ = SADeadlines.shared.close(deadline: self.deadline)
            }else{
                let _ = SADeadlines.shared.reopen(deadline: self.deadline)
            }
            
            
            self.dismiss(animated: true, completion: nil)
        }, for: .touchUpInside)
        
        
        self.content.editButton.addTarget(action: { (sender) in
            let vc = DeadlineEditableModalViewController()
            vc.deadline = self.deadline
            vc.onChange = {
                self.deadline = vc.deadline ?? self.deadline
                self.setupContent()
            }
            self.present(vc, animated: true, completion: nil)
        }, for: .touchUpInside)
        
        
        self.content.deleteButton.addTarget(action: { (sender) in
            let _ = SADeadlines.shared.delete(deadline: self.deadline)
            
            self.dismiss(animated: true, completion: nil)
        }, for: .touchUpInside)
        
        
    }
    
    func setupContent(){
        self.content.nameLabel.text = deadline.deadline_name
        
        self.content.commentLabel.text = deadline.comment
        self.content.commentSectionTitle.isHidden = deadline.comment.isEmpty
        self.content.commentLabel.isHidden = deadline.comment.isEmpty
        if deadline.comment.isEmpty {
            self.content.commentSectionTitle.snp.makeConstraints {$0.height.equalTo(0)}
            self.content.commentLabel.snp.makeConstraints {$0.height.equalTo(0)}
        }
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "RU")
        formatter.dateFormat = "dd MMMM"
        self.content.dateLabel.text = formatter.string(from: deadline.end)
        

        if deadline.subject_name  != nil,deadline.subject_name  != "" {
            self.content.lessonSectionTitle.isHidden = false
            self.content.lessonLabel.isHidden = false
            self.content.lessonLabel.text = deadline.subject_name!
        }else{
            self.content.lessonSectionTitle.isHidden = true
            self.content.lessonLabel.isHidden = true
        }
        
        
        if self.deadline.closed == 0{
            let color = Asset.PocketColors.pocketGreen.color
            self.content.closeButton.setTitleColor(color, for: .normal)
            self.content.closeButton.setTitle("Закрыть дедлайн", for: .normal)
            self.content.closeButton.layer.borderColor = color.cgColor
        }
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        self.onChange?()
        super.dismiss(animated: flag, completion: completion)
    }
    
    
}
