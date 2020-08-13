//
//  TimetableLessonCell.swift
//  rasp.guap
//
//  Created by Кирилл on 10.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit


class TimetableLessonCell: UIButton{
    
    var pocketLessonView:PocketDayView = PocketDayView.fromNib()
    var lesson:Timetable.Lesson? = nil
    var delegate:TimetableLessonCellDelegate? = nil
    init(lesson:Timetable.Lesson? = nil ) {
        super.init(frame:.zero)

        self.addSubview(pocketLessonView)
        self.pocketLessonView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
        }
        
        
//        self.addTarget(self, action: #selector(touchDown(_:)), for: .touchDown)
//        self.addTarget(self, action: #selector(touchUpInside(_:)), for: .touchUpInside)

        if lesson != nil {
            setLesson(lesson: lesson!)
        }
    }
    
    func setLesson(lesson:Timetable.Lesson) {
        self.lesson = lesson
        pocketLessonView.prep.text = lesson.prepods[0].Name
        pocketLessonView.lessonNum.text = "\(lesson.lessonNum)"
        pocketLessonView.title.text = lesson.name
        
        addTag(text: lesson.type.rawValue)
        addTag(text: lesson.groups.count > 1 ? "\(lesson.groups.count) группы" : lesson.groups[0].Name)
        
        var counter = 0
        var place = ""
        for tag in lesson.tags{
            if counter<2{
                place += tag
            }
            counter += 1
        }
        addTag(text: place)
        
        switch lesson.type {
        case .courseProject:
            pocketLessonView.verticalLine.backgroundColor = Asset.PocketColors.pocketPurple.color
            break;
        case .lab:
            pocketLessonView.verticalLine.backgroundColor = Asset.PocketColors.pocketGreen.color
            break
        case .lecture:
            pocketLessonView.verticalLine.backgroundColor = Asset.PocketColors.pocketAqua.color
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
    
//    @objc private func touchDown(_ sender:UIButton){
//        UIView.animate(withDuration: 0.15) {
//            self.backgroundColor = Asset.PocketColors.pocketLightShadow.color
//        }
//    }
//    @objc private func touchUpInside(_ sender:UIButton){
//        UIView.animate(withDuration: 0.15) {
//            self.backgroundColor = .clear
//        }
//        self.delegate?.didSelect(lesson: self.lesson!)
//    }

    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}
protocol TimetableLessonCellDelegate {
    func didSelect(lesson:Timetable.Lesson)
}

