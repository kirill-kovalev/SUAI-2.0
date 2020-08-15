//
//  TimetableViewController.swift
//  rasp.guap
//
//  Created by Кирилл on 10.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit

class TimetableViewController: UIViewController {

    
    let timetable:[Timetable.Lesson]
    private var contentHeight:CGFloat = 0
    let tableView = UIStackView(frame: .zero)
    
    init(timetable:[Timetable.Lesson]? = nil) {
        self.timetable = timetable ?? []
        super.init(nibName: nil, bundle: nil)
        self.view = tableView
        tableView.axis = .vertical
        tableView.layer.cornerRadius = 10
        tableView.spacing = 0
        
        if timetable != nil {
            self.setTimetable(timetable: timetable!)
        }
    }
    func setTimetable(timetable new:[Timetable.Lesson]){
        clearStack()
        for lesson in new {
            let newView = TimetableLessonCell(lesson: lesson)
            newView.addTarget(action: { (sender) in
                let vc = LessonInfoModalViewController(lesson: lesson)
                self.present(vc, animated: true, completion: nil)
            }, for: .touchUpInside)
            self.tableView.addArrangedSubview(newView)
        }
    }
    
    
    
    
    
    
    private func clearStack(){
        for view in self.tableView.arrangedSubviews{
            view.removeConstraints(view.constraints)
            view.removeFromSuperview()
        }
    }
    
    
    required init?(coder: NSCoder) {
        self.timetable = []
        super.init(nibName: nil, bundle: nil)
    }
}
