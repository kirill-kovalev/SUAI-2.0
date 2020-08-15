//
//  ScheduleDaySelectView.swift
//  rasp.guap
//
//  Created by Кирилл on 15.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit

class ScheduleDaySelectView: View {
    let buttons  = ["Пн","Вт","Ср","Чт","Пт","Сб","Вне Сетки"]
    
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
    let stack:UIStackView = {
        let stack = UIStackView(frame: .zero)
        stack.spacing = 0
        stack.axis = .horizontal
        return stack
    }()
    lazy var weekBtn = buttonGenerator("Четная")
    let scroll:UIScrollView = {
        let scroll = UIScrollView(frame: .zero)
        scroll.showsVerticalScrollIndicator = false
        scroll.showsHorizontalScrollIndicator = false
        return scroll
    }()
    
    
    
    required init() {
        super.init()
        
        addViews()
        setupConstraints()
    }
    
    private func addViews(){
        self.addSubview(weekBtn)
        self.addSubview(scroll)
        scroll.addSubview(stack)
        for b in buttons {
            stack.addArrangedSubview(buttonGenerator(b))
        }
    }
    private func setupConstraints(){
        weekBtn.snp.makeConstraints { (make) in
            make.left.top.bottom.equalToSuperview()
        }
        scroll.snp.makeConstraints { (make) in
            make.top.right.bottom.equalToSuperview()
            make.left.equalTo(weekBtn.snp.right).offset(5)
            make.height.equalTo(stack)
        }
        stack.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalTo(scroll.contentLayoutGuide)
        }
    }
    
    required init(coder: NSCoder) {
        super.init()
    }
    
    
    
}
