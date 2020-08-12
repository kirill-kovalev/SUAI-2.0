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
    
    
    // MARK: - View setup
    
    required init() {
        super.init(frame: .zero)
        addViews()
        setupConstraints()
    }
    
    func addViews() {
        self.addSubview(color)
    }
    
    func setupConstraints() {
        color.snp.makeConstraints { (make) in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
