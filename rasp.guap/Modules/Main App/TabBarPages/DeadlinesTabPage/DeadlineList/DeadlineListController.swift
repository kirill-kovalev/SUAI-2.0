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
        tableView.spacing = 12
        
        if list != nil {
            self.setItems(list: list!)
        }
    }
	var actionCounter = 0
    func setItems(list new:[SADeadline]){
        clearStack()
        for deadline in new {
            let newView = DeadlineListCell()
            
            newView.setLessonText(lesson: deadline.subject_name)
            newView.setTitleText(description: deadline.deadline_name)
            newView.setDescriptionText(description: deadline.comment)
            switch deadline.type {
            case .closed:
                newView.setState(state: .closed)
                break
			case .open,.pro:
                newView.setState(state: .open)
                break
            case .nearest:
                newView.setState(state: .nearest)
                break
            }
            self.tableView.addArrangedSubview(newView)
			if !deadline.isPro{
				newView.onCheck { (cell) in
					self.didChecked(deadline: deadline,cell:newView)
				}
			}else{
				newView.checkbox.isHidden = true
				newView.articleIcon.isHidden = true
				newView.calendarIcon.isHidden = true
				newView.titleLabel.snp.remakeConstraints { (make) in
					make.top.greaterThanOrEqualToSuperview()
					make.left.equalTo(newView.imageView.snp.right).offset(12)
					make.right.lessThanOrEqualToSuperview()
					make.centerY.lessThanOrEqualToSuperview()
				}
			}
            
            newView.onSelect { (cell) in
				self.didSelect(deadline: deadline,cell:newView)
            }
            
        }
    }
    
	func didSelect(deadline:SADeadline,cell:DeadlineListCell){
		let vc = DeadlineInfoModalViewController(deadline: deadline)
        vc.onChange = {
			self.delegate?.deadlineDidSelected(deadline: deadline)
        }
        self.present(vc, animated: true, completion: nil)
	}
	func didChecked(deadline:SADeadline,cell:DeadlineListCell){
		cell.indicator.isHidden = false
		cell.checkbox.isHidden = true
		cell.isUserInteractionEnabled = false
		cell.indicator.startAnimating()
		
		DispatchQueue.global(qos: .background).async {
			self.actionCounter += 1
            if deadline.closed == 0 {
				if !SADeadlines.shared.close(deadline: deadline){
					MainTabBarController.Snack(status: .err, text: "Не получилось закрыть дедлайн")
				}else{ MainTabBarController.Snack(status: .ok, text: "Дедлайн успешно закрыт") }
            }else{
				if !SADeadlines.shared.reopen(deadline: deadline) {
					MainTabBarController.Snack(status: .err, text: "Не получилось переоткрыть дедлайн")
				}else{ MainTabBarController.Snack(status: .ok, text: "Дедлайн успешно переоткрыт") }
            }
            self.actionCounter -= 1
			//if !SADeadlines.shared.loadFromServer(){ }//MainTabBarController.Snack(status: .err, text: "Не получилось обновить дедлайны") }

			DispatchQueue.main.async {
				cell.checkbox.isHidden = false
				cell.indicator.stopAnimating()
			}
			DispatchQueue.main.asyncAfter(deadline: .now()+0.3) {
				cell.isUserInteractionEnabled = true
				if self.actionCounter == 0{ self.delegate?.deadlineDidChecked(deadline: deadline) }
				
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
