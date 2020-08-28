//
//  LessonModalViewController.swift
//  rasp.guap
//
//  Created by Кирилл on 12.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit
import SUAI_API

class LessonInfoModalViewController : ModalViewController<LessonInfoModalView>{
    
    var lesson:SALesson
    var delegate:UserChangeDelegate?
    
    init(lesson:SALesson?=nil) {
        self.lesson = lesson ?? SALesson()
        super.init()
    }
    
    required init() {
        self.lesson = SALesson()
        super.init()
    }
    required init?(coder: NSCoder) {
        self.lesson = SALesson()
        super.init(coder:coder)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.rootView.titleLabel.text = "Карточка предмета"
        self.content.nameLabel.text = lesson.name
        
        
        
        func hf(_ int:Int?)->String{ return String(format: "%.2i",  int ?? 0) }
        self.content.timeLabel.text = "\(hf(lesson.startTime.hour)):\(hf(lesson.startTime.minute)) - \(hf(lesson.endTime.hour)):\(hf(lesson.endTime.minute))"
        
        
        func stackElem(_ tagView:PocketTagButton) -> UIStackView{
            let hs = UIStackView(arrangedSubviews: [tagView,UIView(frame: .zero)] )
            hs.axis = .horizontal
            return hs
        }
        for prep in lesson.prepods {
            let tagView = PocketTagButton()
            tagView.setTitle(prep.Name, for: .normal)
            tagView.isActive = (prep != SASchedule.shared.current.user)
            tagView.addTarget(action: { (sender) in
                self.setNewUser(user: prep)
            }, for: .touchUpInside)
            self.content.prepStack.addArrangedSubview(stackElem(tagView))
            
            backgroundUserLoad(user: prep)
        }
        
        for group in lesson.groups{
            let tagView = PocketTagButton()
            tagView.setTitle(group.Name, for: .normal)
            tagView.isActive = (group != SASchedule.shared.current.user)
            tagView.addTarget(action: { (sender) in
                self.setNewUser(user: group)
            }, for: .touchUpInside)
            self.content.groupList.addArrangedSubview(tagView)
            
            backgroundUserLoad(user: group)
        }
        
        let typeTag = PocketTagButton()
        typeTag.setTitle(lesson.type.rawValue, for: .normal)
        self.content.tagStack.addArrangedSubview(typeTag)
        
        for tag in lesson.tags {
            let lessonTag = PocketTagButton()
            lessonTag.setTitle(tag, for: .normal)
            self.content.tagStack.addArrangedSubview(lessonTag)
        }

    }
    
    func setNewUser(user : SAUsers.User){
        
        self.delegate?.didSetUser(user : user)
        self.dismiss(animated: true, completion: nil)
    }
    
    private func backgroundUserLoad(user:SAUsers.User){
        DispatchQueue.global(qos: .background).async {
            let _ = SASchedule.shared.load(for: user)
        }
    }
}


protocol  UserChangeDelegate {
    func didSetUser(user : SAUsers.User)
}
