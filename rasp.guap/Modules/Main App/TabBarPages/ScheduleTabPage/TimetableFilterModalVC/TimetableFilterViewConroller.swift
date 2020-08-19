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

    private var userlist = Schedule.shared.groups
    
    // MARK: - ViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        Schedule.shared.preps.loadFromServer()
        Schedule.shared.groups.loadFromServer()
        setTitle("Фильтр")
//        self.content
        self.content.selector.dataSource = self
        self.content.selector.delegate = self
        
        self.content.searchfield.delegate = self
    }
    

}
extension TimetableFilterViewConroller:UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            self.userlist = Schedule.shared.groups
        }else{
            self.userlist = Schedule.shared.groups.search(name: searchText)
        }
        self.content.selector.reloadAllComponents()
    }
}
extension TimetableFilterViewConroller:UIPickerViewDelegate{
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        Schedule.shared.current.user = userlist.get(index: row)
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
