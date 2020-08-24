//
//  TimetableFilterView.swift
//  rasp.guap
//
//  Created by Кирилл on 31.07.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit

class TimetableFilterView:UIView{
    
    // MARK: - Views
    
    let color:UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor(red: 0x54/0xFF, green: 0xF5/0xFF, blue: 0xBA/0xFF, alpha: 1)
        view.layer.cornerRadius = CornerRadius.default.rawValue
        return view
    }()
    
    private func labelGenerator(_ title:String)->UILabel{
        let label = UILabel(frame: .zero)
        label.font = FontFamily.SFProDisplay.regular.font(size: 14)
        label.textColor = Asset.PocketColors.pocketBlack.color
        label.text = title
        return label
    }
    private func textFieldGenerator(_ title:String = "")->UITextField{
        let field = UITextField(frame: .zero)
        
        field.font = FontFamily.SFProDisplay.regular.font(size: 14)
        
        let img = UIImageView(image: Asset.SystemIcons.searchDropdown.image.withRenderingMode(.alwaysTemplate))
        field.rightView = img
        img.bounds = CGRect(x: 0, y: 0, width: img.bounds.width + 10, height: img.bounds.height)
        field.rightViewMode = .unlessEditing
        
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 12))
        field.leftViewMode = .always
        
        
        field.layer.cornerRadius = 10
        field.backgroundColor = Asset.PocketColors.pocketLightGray.color
        field.textRect(forBounds: field.bounds.insetBy(dx: 5, dy: 5))
        
        
        field.doneAccessory = true
        return field
    }
    
    lazy var grouplabel = labelGenerator("Группа")
    lazy var preplabel = labelGenerator("Преподаватель")
    
    let clearButton:Button = {
        let btn = Button(frame: .zero)
        btn.setTitle("Очистить", for: .normal)
        btn.setTitleColor(Asset.PocketColors.pocketDarkBlue.color, for: .normal)
        btn.titleLabel?.font = FontFamily.SFProDisplay.regular.font(size: 14)
        return btn
    }()
    
    lazy var groupField:UITextField = {
        let field = textFieldGenerator()
        field.placeholder = "Номер группы"
        return field
    }()
    lazy var prepField:UITextField = {
        let field = textFieldGenerator()
        field.placeholder = "Преподаватель"
        return field
    }()
    
    lazy var  selector:UIPickerView = {
        let p = UIPickerView(frame: .zero)
        
        return p
    }()
    
    
    
    
    
    
    // MARK: - View setup
    
    required init() {
        super.init(frame: .zero)
        addViews()
        setupConstraints()
    }
    
    func addViews() {
        self.addSubview(grouplabel)
        self.addSubview(groupField)
        self.addSubview(preplabel)
        self.addSubview(prepField)
        self.addSubview(clearButton)
        self.addSubview(selector)
    }
    
    func setupConstraints() {
        grouplabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()
        }
        groupField.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(40)
            make.top.equalTo(grouplabel.snp.bottom).offset(10)
        }
        preplabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(groupField.snp.bottom).offset(10)
        }
        prepField.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(40)
            make.top.equalTo(preplabel.snp.bottom).offset(10)
        }
        selector.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(prepField.snp.bottom).offset(10)
            make.height.equalTo(0)
            make.bottom.equalToSuperview()
        }
        
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
