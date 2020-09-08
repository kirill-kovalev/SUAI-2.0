//
//  TimetableLessonCell.swift
//  rasp.guap
//
//  Created by Кирилл on 10.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit
import SUAI_API


class TimetableLessonCell: UIView{
    
    private var pocketLessonView:PocketDayView = PocketDayView.fromNib()
    private var lesson:SALesson? = nil
    
    private let btn:Button = {
        let btn = Button(frame: .zero)
        return btn
    }()
    
    init(lesson:SALesson? = nil ) {
        super.init(frame:.zero)
        
        addViews()
        setupConstraints()
        
        if lesson != nil {
            setLesson(lesson: lesson!)
        }
    }
    private func addViews(){
        self.addSubview(pocketLessonView)
    }
    private func setupConstraints(){
        self.pocketLessonView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
        }
    }
    
    
    func setLesson(lesson:SALesson) {
        self.lesson = lesson
        
        pocketLessonView.prep.text = lesson.prepods.isEmpty ? "Преподаватель не указан" : lesson.prepods[0].Name
        pocketLessonView.lessonNum.text = "\(lesson.lessonNum)"
        pocketLessonView.title.text = lesson.name
        
        addTag(text: lesson.type.rawValue)
        addTag(text: lesson.groups.count > 1 ? "\(lesson.groups.count) группы" : lesson.groups[0].Name)
        
        for tag in lesson.tags{
            addTag(text: tag)
        }
        
        
        switch lesson.type {
        case .courseProject:
            pocketLessonView.verticalLine.backgroundColor = Asset.PocketColors.pocketGreen.color
            break;
        case .lab:
            pocketLessonView.verticalLine.backgroundColor = Asset.PocketColors.pocketAqua.color
            break
        case .lecture:
            pocketLessonView.verticalLine.backgroundColor = Asset.PocketColors.pocketPurple.color
            break
            
        case .practice:
            pocketLessonView.verticalLine.backgroundColor = Asset.PocketColors.pocketOrange.color
            break

        }
       
        func hf(_ int:Int?)->String{
             return String(format: "%.2i",  int ?? 0)
        }
        
        pocketLessonView.startTime.text = "\(hf(lesson.startTime.hour)):\(hf(lesson.startTime.minute!))"
        pocketLessonView.endTime.text = "\(hf(lesson.endTime.hour!)):\(hf(lesson.endTime.minute!))"

        
        
        
    }
    private func addTag(text: String){
        let tag = PocketTagButton()
        tag.setTitle(text, for: .normal)
        tag.isEnabled = false
        pocketLessonView.tagStack.addArrangedSubview(tag)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}
