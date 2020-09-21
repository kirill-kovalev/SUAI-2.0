//
//  DeadlineEditableModalViewController.swift
//  rasp.guap
//
//  Created by Кирилл on 24.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit
import SUAI_API

class DeadlineEditableModalViewController : ModalViewController<DeadlineEditModalView>{
	
	var deadline:SADeadline?
	
	var onChange:(()->Void)?
	
	var lessonList:[SALesson] = []
	
	override func viewDidLoad() {
		super.viewDidLoad()
		let picker = UIPickerView()
		picker.delegate = self
		self.content.lessonLabel.inputView = picker
		DispatchQueue.global(qos: .background).async {
			self.lessonList = SASchedule.shared.get(for: SASchedule.shared.groups.get(name: SAUserSettings.shared.group ?? "") ?? SAUsers.User(Name: "", ItemId: 0)).list()
			DispatchQueue.main.async {
				picker.reloadAllComponents()
			}
		}
		
		for item in [self.content.lessonLabel, self.content.dateLabel,self.content.nameLabel]{
			item.addTarget(self, action: #selector(self.textViewDidChange(_:)), for: .editingChanged)
		}
		self.content.commentLabel.delegate = self
		
		
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		if self.deadline == nil { // Создание
			self.setTitle("Создать дедлайн")
			
			self.content.closeButton.addTarget(action: { (btn) in
				self.deadline = SADeadline(id: 0,
																	   subject_name: self.content.lessonLabel.text,
																	   deadline_name: self.content.nameLabel.text ?? "",
																	   closed: 0,
																	   start: Date(),
																	   end: self.content.datePicker.date,
																	   comment: self.content.commentLabel.text
				)
				if !SADeadlines.shared.create(deadline: self.deadline!) {
					MainTabBarController.Snack(status: .err, text: "Не получилось создать дедлайн")
				}else{
					MainTabBarController.Snack(status: .ok, text: "Дедлайн успешно создан")
				}
				self.dismiss(animated: true)
				
			}, for: .touchUpInside)
			
			
		}else{ //Редактирование
			self.setTitle("Редактировать дедлайн")
			self.content.closeButton.setTitle("Обновить дедлайн", for: .normal)
			self.content.nameLabel.text = deadline!.deadline_name
			self.content.commentLabel.text = deadline!.comment
			self.content.dateLabel.text = self.content.formatter.string(from: deadline?.end ?? Date())
			(self.content.dateLabel.inputView as? UIDatePicker)?.date = deadline?.end ?? Date()
			
			self.content.closeButton.addTarget(action: { (btn) in
				self.deadline = SADeadline(id: self.deadline!.id,
																		subject_name: self.content.lessonLabel.text,
																		deadline_name: self.content.nameLabel.text ?? "",
																		closed: 0,
																		start: Date(),
																		end: self.content.datePicker.date,
																		comment: self.content.commentLabel.text
				)
				if !SADeadlines.shared.edit(deadline: self.deadline!  ){
					MainTabBarController.Snack(status: .err, text: "Не получилось обновить дедлайн")
				}
				self.dismiss(animated: true)
			}, for: .touchUpInside)
			
			
		}
		self.textViewDidChange(self.content.commentLabel)
	}
	
	
	func checkModal()->Bool{
		if (self.content.nameLabel.text?.count ?? 0) < 1 || (self.content.nameLabel.text?.count ?? 0) > 50 { return false}
		if (self.content.commentLabel.text?.count ?? 0) > 300 { return false}
		let date = self.content.datePicker.date
		let todayStr = self.content.formatter.string(from: Date())
		let today = self.content.formatter.date(from: todayStr) ?? Date()
		if date < today || date > Date().addingTimeInterval(60*60*24*365) {return false}
		return true
	}
	
	
	override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        self.onChange?()
        super.dismiss(animated: flag, completion: completion)
    }
}
extension DeadlineEditableModalViewController:UIPickerViewDataSource{
	func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int { self.lessonList.count+1 }
	
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return row == 0 ? "Не выбрано"  : lessonList[row-1].name
	}
}

extension DeadlineEditableModalViewController:UIPickerViewDelegate{
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		self.content.lessonLabel.text = row == 0 ? ""  : lessonList[row-1].name
	}
}

extension DeadlineEditableModalViewController:UITextViewDelegate{
	@objc func textViewDidChange(_ textView: UITextView) {
		self.content.closeButton.isEnabled = self.checkModal()
		self.content.closeButton.layer.borderColor = self.content.closeButton.titleLabel?.textColor.cgColor
	}
}
