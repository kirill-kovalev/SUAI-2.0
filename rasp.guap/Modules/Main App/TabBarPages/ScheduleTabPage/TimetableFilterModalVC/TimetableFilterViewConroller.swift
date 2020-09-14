//
//  TimetableFilterViewConroller.swift
//  rasp.guap
//
//  Created by Кирилл on 31.07.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit
import SUAI_API

class TimetableFilterViewConroller: ModalViewController<TimetableFilterView> {
    
    
    private var userlist:SAUsers = SASchedule.shared.groups
    
    private var activeTF:UITextField? = nil
	
	var currentUser:SAUsers.User? = nil
    var delegate:UserChangeDelegate?
    
    // MARK: - ViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        setTitle("Фильтр")
        self.content.selector.dataSource = self
        self.content.selector.delegate = self
        
        self.content.groupField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        self.content.prepField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        
        self.content.groupField.delegate = self
        self.content.prepField.delegate = self
        
        
        self.content.clearButton.addTarget(action: { (sender) in
            if SAUserSettings.shared != nil {
                guard let user = SASchedule.shared.groups.get(name: SAUserSettings.shared!.group!) else { return }
                self.delegate?.didSetUser(user: user)
                self.dismiss(animated: true, completion: nil)
            }
            
        }, for: .touchUpInside)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
		
		if let name = self.currentUser?.Name {
			
			if SASchedule.shared.preps.get(name:name) != nil{
				self.content.prepField.text = name
			} else if SASchedule.shared.groups.get(name: name) != nil {
				self.content.groupField.text = name
			}
		}
		
        DispatchQueue.global(qos: .background).async {
            SAUserSettings.shared?.reload()
            SASchedule.shared.preps.loadFromServer()
            SASchedule.shared.groups.loadFromServer()
        }
    }
    

    
}

extension TimetableFilterViewConroller : UITextFieldDelegate{
	
    func textFieldDidBeginEditing(_ textField: UITextField) {
		
        self.activeTF = textField
        if self.content.groupField == textField{
            self.content.prepField.text = ""
        }else{
            self.content.groupField.text = ""
        }
        textFieldDidChange(textField)
		if let text = textField.text{
			if let row = self.userlist.index(name: text) {
				self.content.selector.selectRow(row+1, inComponent: 0, animated: false)
			}
		}
//		self.content.selector.resignFirstResponder()

        
		self.content.selector.snp.updateConstraints { (make) in
            make.height.equalTo(250)
        }
		
		
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.activeTF = nil
        
        self.content.selector.snp.updateConstraints { (make) in
            make.height.equalTo(0)
        }
        guard let text = textField.text,
              let user = userlist.search(name: text).get(index: 0) else { return }
        self.delegate?.didSetUser(user: user)
        
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        var baseUserlist:SAUsers
        if textField == self.content.groupField{
            baseUserlist = SASchedule.shared.groups
        }else{
            baseUserlist = SASchedule.shared.preps
        }
        
        
        let searchText = textField.text ?? ""
        
        if searchText == "" {
            self.userlist = baseUserlist
        }else{
            self.userlist = baseUserlist.search(name: searchText)
        }
        
        self.content.selector.reloadAllComponents()
        
    }

    
}


extension TimetableFilterViewConroller:UIPickerViewDelegate{
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		if let user = userlist.get(index: row-1){
			self.activeTF?.text = user.shortName
			self.delegate?.didSetUser(user: user)
		}else{
			self.activeTF?.text = ""
			if activeTF != nil {self.textFieldDidChange(activeTF!)}
			
		}
    }
}
extension TimetableFilterViewConroller:UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return userlist.count+1
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		if row == 0 {return "---"}
		return userlist.get(index: row-1)?.shortName
    }
   
}
