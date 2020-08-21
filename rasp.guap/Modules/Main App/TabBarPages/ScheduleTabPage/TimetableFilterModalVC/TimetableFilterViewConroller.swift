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

    private var userlist = SASchedule.shared.groups
    
    var delegate:UserChangeDelegate?
    
    // MARK: - ViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        setTitle("Фильтр")
//        self.content
        self.content.selector.dataSource = self
        self.content.selector.delegate = self
        
        self.content.searchfield.delegate = self
        
        self.content.clearButton.addTarget(action: { (sender) in
            if SAUserSettings.shared != nil {
                guard let user = SASchedule.shared.groups.get(name: SAUserSettings.shared!.group) else { return }
                self.delegate?.didSetUser(user: user)
                self.dismiss(animated: true, completion: nil)
            }
            
        }, for: .touchUpInside)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.global(qos: .background).async {
            SAUserSettings.shared?.update()
            SASchedule.shared.preps.loadFromServer()
            SASchedule.shared.groups.loadFromServer()
            DispatchQueue.main.async {
                self.userlist = SASchedule.shared.groups
                self.content.selector.reloadAllComponents()
            }
        }
    }
    
    

}
extension TimetableFilterViewConroller:UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            self.userlist = SASchedule.shared.groups
        }else{
            self.userlist = SASchedule.shared.groups.search(name: searchText)
        }
        self.content.selector.reloadAllComponents()
    }
}
extension TimetableFilterViewConroller:UIPickerViewDelegate{
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let user = userlist.get(index: row) else { return }
        self.delegate?.didSetUser(user: user)
    }
}
extension TimetableFilterViewConroller:UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return userlist.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return userlist.get(index: row)?.Name
    }
    
    
}
