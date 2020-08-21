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
    
    var delegate:DeadlineListDelegate?
    
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
            let newView = DeadlineListCell()
            newView.setLessonText(lesson: nil)
            newView.setTitleText(description: deadline.subjectname)
            newView.setDescriptionText(description: deadline.comment)
            print("desc: \(deadline.subjectname)")
            switch deadline.type {
            case .closed:
                newView.setState(state: .closed)
                break
            case .open:
                newView.setState(state: .open)
                break
            case .nearest:
                newView.setState(state: .nearest)
                break
            }
            self.tableView.addArrangedSubview(newView)
            
            newView.onCheck { (cell) in
                self.delegate?.deadlineDidChecked(deadline: deadline)
            }
            newView.onSelect { (cell) in
                self.delegate?.deadlineDidSelected(deadline: deadline)
            }
            
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


protocol DeadlineListDelegate {
    func deadlineDidSelected(deadline:SADeadline)
    func deadlineDidChecked(deadline:SADeadline)
}
