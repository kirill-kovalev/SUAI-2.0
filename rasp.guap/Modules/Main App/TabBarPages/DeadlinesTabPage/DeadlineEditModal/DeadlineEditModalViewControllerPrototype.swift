//
//  DeadlineEditModalViewController.swift
//  rasp.guap
//
//  Created by Кирилл on 24.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit
import SUAI_API

class DeadlineEditableModalViewController: ModalViewController<DeadlineEditModalView> {
    var deadline: SADeadline?
    
    var onChange:(() -> Void)?
    
    var lessonList = SASchedule.shared.get(for: SASchedule.shared.groups.get(name: SAUserSettings.shared?.group ?? "") ?? SAUsers.User(Name: "", ItemId: 0)).list()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let picker = UIPickerView()
        picker.delegate = self
        self.content.lessonLabel.inputView = picker
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.deadline == nil { // Создание
            self.setTitle("Создать дедлайн")
        } else { //Редактирование
            self.setTitle("Редактировать дедлайн")
            self.content.nameLabel.text = deadline!.deadline_name
            self.content.commentLabel.text = deadline!.comment
            self.content.dateLabel.text = self.content.formatter.string(from: deadline?.end ?? Date())
            (self.content.dateLabel.inputView as? UIDatePicker)?.date = deadline?.end ?? Date()
        }
    }
}
extension DeadlineEditableModalViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int { self.lessonList.count+1 }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return row == 0 ? "Не выбрано"  : lessonList[row-1].name
    }
}

extension DeadlineEditableModalViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.content.lessonLabel.text = row == 0 ? ""  : lessonList[row-1].name
    }
}
