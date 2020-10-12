//
//  TimetableViewController.swift
//  rasp.guap
//
//  Created by Кирилл on 10.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit
import SUAI_API

class TimetableViewController: UIViewController {
    let timetable: [SALesson]
    private var contentHeight: CGFloat = 0
    let tableView = UIStackView(frame: .zero)
    
    var cellDelegate: UserChangeDelegate?
    
    init(timetable: [SALesson]? = nil) {
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
    func setTimetable(timetable new: [SALesson]) {
        clearStack()
        for lesson in new {
			let cell = TimetableLessonCell(lesson: lesson)
			let newView = PocketScalableContainer(content: cell.pocketLessonView)
            newView.addTarget(action: { (_) in
                let vc = LessonInfoModalViewController(lesson: lesson)
                vc.delegate = self.cellDelegate
				vc.curUser = (self.parent as? ScheduleTabViewController)?.currentUser
                self.present(vc, animated: true, completion: nil)
            }, for: .touchUpInside)
            self.tableView.addArrangedSubview(newView)
        }
    }
    
    private func clearStack() {
        for view in self.tableView.arrangedSubviews {
            view.removeConstraints(view.constraints)
            view.removeFromSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        self.timetable = []
        super.init(nibName: nil, bundle: nil)
    }
}
