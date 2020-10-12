//
//  DeadlineInfoModalViewController.swift
//  rasp.guap
//
//  Created by Кирилл on 19.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit
import SUAI_API

class DeadlineInfoModalViewController: ModalViewController<DeadlineInfoModalView> {
    var deadline: SADeadline
    
    var onChange:(() -> Void)?
    
    init(deadline: SADeadline?=nil) {
        self.deadline = deadline ?? SADeadline()
        super.init()
    }
    
    required init() {
        self.deadline = SADeadline()
        super.init()
    }
    required init?(coder: NSCoder) {
        self.deadline = SADeadline()
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.rootView.titleLabel.text = "Карточка Дедлайна"
        
        setupContent()
        
        self.content.editButton.addTarget(action: { (_) in
            let vc = DeadlineEditableModalViewController()
            vc.deadline = self.deadline
            vc.onChange = {
                self.deadline = vc.deadline ?? self.deadline
                self.setupContent()
            }
            self.present(vc, animated: true, completion: nil)
        }, for: .touchUpInside)
        
        self.content.closeButton.addTarget(action: { (_) in
			if self.deadline.closed == 0 {
				self.closeDeadline()
            } else {
				self.reopenDeadline()
            }
			
        }, for: .touchUpInside)
        
        self.content.deleteButton.addTarget(action: { (sender) in
			(sender as? PocketLongActionButton)?.disable()
			self.content.isUserInteractionEnabled = false
			DispatchQueue.global().async {
				let success = SADeadlines.shared.delete(deadline: self.deadline)
				if !success {
					MainTabBarController.Snack(status: .err, text: "Не удалось удалить дедлайн")
				} else {
					MainTabBarController.Snack(status: .ok, text: "Дедлайн успешно удален")
				}
				
				DispatchQueue.main.async {
					(sender as? PocketLongActionButton)?.enable()
					self.content.isUserInteractionEnabled = false
					
					self.onChange?()
					if success { self.dismiss(animated: true, completion: nil) }
				}
			}
			
        }, for: .touchUpInside)
        
    }
	private func closeDeadline() {
		self.content.closeButton.disable()
		self.content.isUserInteractionEnabled = false
		DispatchQueue.global().async {
			let success = SADeadlines.shared.close(deadline: self.deadline)
			if !success {
				MainTabBarController.Snack(status: .err, text: "Не получилось закрыть дедлайн")
			} else {
				MainTabBarController.Snack(status: .ok, text: "Дедлайн успешно закрыт")
			}
			DispatchQueue.main.async {
				self.content.closeButton.enable()
				self.content.isUserInteractionEnabled = true
				if success {
					self.onChange?()
					self.dismiss(animated: true, completion: nil)
				}
			}
			
		}
		
	}
	private func reopenDeadline() {
		self.content.closeButton.disable()
		self.content.isUserInteractionEnabled = false
		DispatchQueue.global().async {
			let success = SADeadlines.shared.reopen(deadline: self.deadline)
			if !success {
				MainTabBarController.Snack(status: .err, text: "Не получилось переоткрыть дедлайн")
			} else {
				MainTabBarController.Snack(status: .ok, text: "Дедлайн успешно переоткрыт")
			}
			DispatchQueue.main.async {
				self.content.closeButton.enable()
				self.content.isUserInteractionEnabled = true
				if success {
					self.onChange?()
					self.dismiss(animated: true, completion: nil)
				}
			}
			
		}
	}
    
    func setupContent() {
		for v in self.content.arrangedSubviews {
			self.content.removeArrangedSubview(v)
			v.removeFromSuperview()
		} // clear
		if let name =  deadline.deadline_name { self.content.addBlock(title: "Название дедлайна", text: name) }
		if let type = self.deadline.type_name {self.content.addBlock(title: "Тип", text: type)}
		if !deadline.comment.isEmpty { self.content.addBlock(title: "Описание дедлайна", text: deadline.comment) }
		if let end =  deadline.end {
			let formatter = DateFormatter()
			formatter.locale = Locale(identifier: "RU")
			formatter.dateFormat = "dd MMMM"
			self.content.addBlock(title: "Дата дедлайна", text: formatter.string(from: end) )
		}
		if let subj =  deadline.subject_name, !subj.isEmpty { self.content.addBlock(title: "Предмет", text: subj) }
		if let mark = self.deadline.markpoint {
			self.content.addArrangedSubview(self.content.sectionLabelGenerator("Баллы"))
			let btn = PocketTagButton(frame: .zero)
			btn.setTitle(mark, for: .normal)
			btn.isActive = false
			let s = UIStackView(arrangedSubviews: [btn, UIView(frame: .zero)])
			self.content.addArrangedSubview(s)
			
		}
		if let status = self.deadline.status_name {
			self.content.addArrangedSubview(self.content.sectionLabelGenerator("Статус"))
			let btn = PocketTagButton(frame: .zero)
			btn.setTitle(status, for: .normal)
			btn.isActive = false
			let s = UIStackView(arrangedSubviews: [btn, UIView(frame: .zero)])
			self.content.addArrangedSubview(s)
			
		}
        
        if self.deadline.closed == 0 {
            let color = Asset.PocketColors.pocketGreen.color
            self.content.closeButton.setTitleColor(color, for: .normal)
            self.content.closeButton.setTitle("Закрыть дедлайн", for: .normal)
            self.content.closeButton.layer.borderColor = color.cgColor
        }
		
		if !self.deadline.isPro {
			self.content.addArrangedSubview(self.content.buttonContainer)
		}
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        self.onChange?()
        super.dismiss(animated: flag, completion: completion)
    }
    
}
