//
//  FourthPageViewController.swift
//  rasp.guap
//
//  Created by Кирилл on 06.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit
import SUAI_API

class FourthPageViewController : ViewController<FourthPageView> {
    
    // MARK: - View Controller lifecycle
    override func loadView() {
        super.loadView()
    }
    let preparedData:[Lesson] = [
        Lesson(name: "Линейная алгебра", lessonNum: 1, type: .lab, prepod: Preps.Prepod(Name: "Смирнов А.О.", ItemId: 0), group: Groups.Group(Name: "М611", ItemId: 0), tags: ["Гаст. 24-12"]),
        Lesson(name: "Дифференциальные уравнения", lessonNum: 2, type: .lecture, prepod: Preps.Prepod(Name: "Смирнов А.О.", ItemId: 0), group: Groups.Group(Name: "М611", ItemId: 0), tags: ["Б.М. 12-10"]),
        Lesson(name: "Линейная алгебра", lessonNum: 3, type: .practice, prepod: Preps.Prepod(Name: "Смирнов А.О.", ItemId: 0), group: Groups.Group(Name: "М611", ItemId: 0), tags: ["Гаст. 24-12"])
    ]
    override func viewDidLoad() {
        let timetable = TimetableViewController(timetable: preparedData)
        timetable.view.isUserInteractionEnabled = false
        
        self.addChild(timetable)
        self.rootView.tableContainer.addSubview(timetable.view)
        timetable.tableView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalToSuperview()
        }
        timetable.didMove(toParent: self)
    }
    
}

