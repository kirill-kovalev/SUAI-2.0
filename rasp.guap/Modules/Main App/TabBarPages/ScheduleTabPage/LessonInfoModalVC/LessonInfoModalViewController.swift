//
//  LessonModalViewController.swift
//  rasp.guap
//
//  Created by Кирилл on 12.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit

class LessonInfoModalViewController : ModalViewController<LessonInfoModalView>{
    
    var lesson:Timetable.Lesson
    
    init(lesson:Timetable.Lesson?=nil) {
        self.lesson = lesson ?? Timetable.Lesson()
        super.init()
    }
    
    required init() {
        self.lesson = Timetable.Lesson()
        super.init()
    }
    required init?(coder: NSCoder) {
        self.lesson = Timetable.Lesson()
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
            tagView.isActive = (prep != Schedule.shared.current.user)
            tagView.addTarget(action: { (sender) in
                self.setNewUser(user: prep)
            }, for: .touchUpInside)
            self.content.prepStack.addArrangedSubview(stackElem(tagView))
        }
        
        for group in lesson.groups{
            let tagView = PocketTagButton()
            tagView.setTitle(group.Name, for: .normal)
            tagView.isActive = (group != Schedule.shared.current.user)
            tagView.addTarget(action: { (sender) in
                self.setNewUser(user: group)
            }, for: .touchUpInside)
            self.content.groupList.addArrangedSubview(tagView)
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
    
    func setNewUser(user : Schedule.User){
        //SOME CODE TO CHANGE CURRENT SCHEDULE USER
        print(user)
        Schedule.shared.current.user = user
        self.dismiss(animated: true, completion: nil)
    }
}
