//
//  ScheduleDaySelectView.swift
//  rasp.guap
//
//  Created by Кирилл on 15.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit

class ScheduleDaySelectView: View {
    
    
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
    
    lazy var weekBtn = buttonGenerator("Четная")
	lazy var daySelector:SwitchSelector = {
		let s = SwitchSelector(frame: .zero)
		
		return s
	}()
    
    
    
    required init() {
        super.init()
        
        addViews()
        setupConstraints()
    }
    
    private func addViews(){
        self.addSubview(weekBtn)
		self.addSubview(daySelector)
    }
    private func setupConstraints(){
        weekBtn.snp.makeConstraints { (make) in
            make.left.top.bottom.equalToSuperview()
        }
        daySelector.snp.makeConstraints { (make) in
            make.top.right.bottom.equalToSuperview()
            make.left.equalTo(weekBtn.snp.right).offset(10)
        }
    }
    
    required init(coder: NSCoder) {
        super.init()
    }
    
    
    
}
