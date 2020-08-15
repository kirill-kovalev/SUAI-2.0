//
//  ScheduleDaySelectView.swift
//  rasp.guap
//
//  Created by Кирилл on 15.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit

class ScheduleDaySelectView: UIStackView {
    let buttons  = ["Четная","Пн","Вт","Ср","Чт","Пт","Сб","Вне Сетки"]
    
    private func buttonGenerator(_ title:String)->Button{
        let btn = Button(frame: .zero)
        btn.setTitle(title, for: .normal)
        btn.titleLabel?.font = FontFamily.SFProDisplay.semibold.font(size: 14)
        btn.backgroundColor = .red
        btn.layer.cornerRadius = 10
        btn.titleLabel?.snp.makeConstraints({ (make) in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().inset(15)
            make.top.equalToSuperview().offset(7)
            make.bottom.equalToSuperview().inset(7)
        })
        return btn;
    }
    
    
    init() {
        super.init(frame:.zero)
        self.spacing = 5
        for b in buttons {
            self.addArrangedSubview(buttonGenerator(b))
        }
    }
    required init(coder: NSCoder) {
        super.init(frame:.zero)
    }
    
    
    
}
