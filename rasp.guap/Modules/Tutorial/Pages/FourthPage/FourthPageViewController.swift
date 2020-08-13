//
//  FourthPageViewController.swift
//  rasp.guap
//
//  Created by Кирилл on 06.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit

class FourthPageViewController : ViewController<FourthPageView> {
    
    // MARK: - View Controller lifecycle
    override func loadView() {
        super.loadView()
    }
    let preparedData:[Timetable.Lesson] = [
        Timetable.Lesson(name: "Линейная алгебра", lessonNum: 1, type: .lab, prepod: Preps.Prepod(Name: "Смирнов А.О.", ItemId: 0), group: Groups.Group(Name: "М611", ItemId: 0), tags: ["Гаст. 24-12"]),
        Timetable.Lesson(name: "Дифференциальные уравнения", lessonNum: 2, type: .lecture, prepod: Preps.Prepod(Name: "Смирнов А.О.", ItemId: 0), group: Groups.Group(Name: "М611", ItemId: 0), tags: ["Б.М. 12-10"]),
        Timetable.Lesson(name: "Линейная алгебра", lessonNum: 3, type: .practice, prepod: Preps.Prepod(Name: "Смирнов А.О.", ItemId: 0), group: Groups.Group(Name: "М611", ItemId: 0), tags: ["Гаст. 24-12"])
    ]
    override func viewDidLoad() {
        let timetable = TimetableViewController(timetable: preparedData)
        let someview = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        someview.backgroundColor = .red
        
        self.addChild(timetable)
        self.rootView.tableContainer.addSubview(timetable.view)
        
        
        
        timetable.tableView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalToSuperview()
        }
        timetable.didMove(toParent: self)
    }
    
}

