//
//  TimetableViewController.swift
//  rasp.guap
//
//  Created by Кирилл on 10.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit

class TimetableViewController: UITableViewController {
    private let lessonCellID = "lessonCell"
    
    let timetable:[Timetable.Lesson]
    private var contentHeight:CGFloat = 0
    init(timetable:[Timetable.Lesson]) {
        self.timetable = timetable
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        self.timetable = []
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.layer.cornerRadius = 10
        tableView.layer.masksToBounds = true
        tableView.register(TimetableLessonCell.self, forCellReuseIdentifier: lessonCellID)
        //tableView.reloadData()
    }
    override func viewDidAppear(_ animated: Bool) {
        tableView.snp.makeConstraints { (make) in
            make.height.equalTo(contentHeight)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.lessonCellID , for: indexPath) as! TimetableLessonCell
        let i = indexPath.row
        cell.pocketLessonView.prep.text = timetable[i].prepods[0].Name
        cell.pocketLessonView.lessonNum.text = "\(timetable[i].lessonNum)"
        cell.pocketLessonView.title.text = timetable[i].name
        self.contentHeight += cell.frame.height*2 - 5
        return cell
        
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timetable.count
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        let modal = LessonInfoModalViewController()
        self.present(modal, animated: true, completion: {
            self.tableView.deselectRow(at: indexPath, animated: true)
        })
    }
}

