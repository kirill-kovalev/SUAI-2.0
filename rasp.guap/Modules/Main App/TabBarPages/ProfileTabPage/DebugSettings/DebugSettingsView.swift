//
//  DebugSettingsView.swift
//  rasp.guap
//
//  Created by Кирилл on 04.10.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit

class DebugSettingsView: View {
	let stack:UIStackView = {
		let s = UIStackView(frame: .zero)
		s.axis = .vertical
		s.alignment = .fill
		s.spacing = 5
		return s
	}()
	let textField = UITextViewFixed(frame: .zero)
	let oldimetable = AppSettingsBlock(title: "Старое расписание")
	let goodTB = AppSettingsBlock(title: "Правильный таб бар")
	required init(){
		super.init()
		
		self.backgroundColor = .clear
		self.addSubview(stack)
		stack.snp.makeConstraints { (make) in
			make.top.left.right.bottom.equalToSuperview()
			make.height.greaterThanOrEqualTo(350)
		}
		
		stack.addArrangedSubview(oldimetable)
		stack.addArrangedSubview(goodTB)
		stack.addArrangedSubview(textField)
		
	}
	
	required init(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
