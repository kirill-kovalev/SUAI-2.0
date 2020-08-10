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
    override func viewDidLoad() {
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.layer.cornerRadius = 10
        tableView.layer.masksToBounds = true
        //tableView.isScrollEnabled = false
        
        tableView.register(TimetableLessonCell.self, forCellReuseIdentifier: lessonCellID)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.lessonCellID , for: indexPath) as! TimetableLessonCell
        
        return cell
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height/3
    }
}

