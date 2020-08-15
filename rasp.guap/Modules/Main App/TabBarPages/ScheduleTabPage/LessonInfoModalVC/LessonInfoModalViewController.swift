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
        
        for prep in lesson.prepods {
            let tagView = PocketTagButton()
            tagView.setTitle(prep.Name, for: .normal)
            tagView.isActive = false
            tagView.addTarget(action: { (sender) in
                //SOME CODE TO CHANGE CURRENT SCHEDULE USER
                self.dismiss(animated: true, completion: nil)
            }, for: .touchUpInside)
            self.content.prepStack.addArrangedSubview(tagView)
        }
        
    }
    
//        switch lesson.type {
//        case .courseProject:
//
//            self.content.backgroundColor = Asset.PocketColors.pocketPurple.color
//            break;
//        case .lab:
//            self.content.backgroundColor = Asset.PocketColors.pocketGreen.color
//            break
//        case .lecture:
//            self.content.backgroundColor = Asset.PocketColors.pocketAqua.color
//            break
//
//        case .practice:
//            self.content.backgroundColor = Asset.PocketColors.pocketOrange.color
//            break
//
//        }
    //}
}
