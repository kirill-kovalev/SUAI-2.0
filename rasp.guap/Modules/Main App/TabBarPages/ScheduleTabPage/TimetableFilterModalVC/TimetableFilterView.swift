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
    private func buttonGenerator(_ title:String)->Button{
        let btn = Button(frame: .zero)
        btn.setImage(Asset.SystemIcons.searchDropdown.image.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.backgroundColor = Asset.PocketColors.pocketGray.color
        return btn
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
    
    let searchfield:UISearchBar = {
        let s = UISearchBar(frame: .zero)
        s.searchBarStyle = .minimal
        return s
    }()
    
    let selector:UIPickerView = {
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
        self.addSubview(preplabel)
        self.addSubview(clearButton)
        self.addSubview(selector)
        self.addSubview(searchfield)
    }
    
    func setupConstraints() {
        clearButton.snp.makeConstraints { (make) in
            make.top.right.equalToSuperview()
        }
        searchfield.snp.makeConstraints { (make) in
            make.top.equalTo(clearButton.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(44)
        }
        selector.snp.makeConstraints { (make) in
            make.bottom.left.right.equalToSuperview()
            make.top.equalTo(searchfield.snp.bottom)
        }
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
