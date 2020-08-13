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
        
        let tag = PocketTagButton()
        tag.setTitle("\(lesson.type.rawValue)", for: .normal)
        tag.isEnabled = false
        pocketLessonView.tagStack.addArrangedSubview(tag)
        
        
        let groupTag = PocketTagButton()
        if lesson.groups.count > 1 {
            groupTag.setTitle("\(lesson.groups.count) группы", for: .normal)
        }else{
            groupTag.setTitle(lesson.groups[0].Name, for: .normal)
        }
        groupTag.isEnabled = false
        pocketLessonView.tagStack.addArrangedSubview(groupTag)
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

