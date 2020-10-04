//
//  DebugSettingsView.swift
//  rasp.guap
//
//  Created by Кирилл on 04.10.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit

class DebugSettingsView: ModalView {
	let stack:UIStackView = {
		let s = UIStackView(frame: .zero)
		s.axis = .vertical
		s.alignment = .fill
		return s
	}()
	let textField = UITextViewFixed(frame: .zero)
	let oldimetable = AppSettingsBlock(title: "Старое расписание")
	required init(){
		super.init()
		oldimetable.backgroundColor = .clear
		self.addSubview(stack)
		stack.snp.makeConstraints { (make) in
			make.top.left.right.bottom.equalToSuperview()
			make.height.greaterThanOrEqualTo(350)
		}
		
		stack.addArrangedSubview(oldimetable)
		stack.addArrangedSubview(textField)
		
	}
	
	required init(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
