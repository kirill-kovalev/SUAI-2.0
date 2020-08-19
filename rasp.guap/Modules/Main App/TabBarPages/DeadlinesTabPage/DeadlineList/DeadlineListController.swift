//
//  DeadlineListController.swift
//  rasp.guap
//
//  Created by Кирилл on 19.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//


import UIKit
import SUAI_API

class DeadlineListController: UIViewController {

    
    let list:[SADeadline]
    private var contentHeight:CGFloat = 0
    let tableView = UIStackView(frame: .zero)
    
    init(list:[SADeadline]? = nil) {
        self.list = list ?? []
        super.init(nibName: nil, bundle: nil)
        self.view = tableView
        tableView.axis = .vertical
        tableView.layer.cornerRadius = 10
        tableView.spacing = 8
        
        if list != nil {
            self.setItems(list: list!)
        }
    }
    func setItems(list new:[SADeadline]){
        clearStack()
        for deadline in new {
            let newView = PocketDeadlineView()
            newView.setLessonText(lesson: nil)
            newView.setDescriptionText(description: deadline.subjectname)
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
        self.list = []
        super.init(nibName: nil, bundle: nil)
    }
}

