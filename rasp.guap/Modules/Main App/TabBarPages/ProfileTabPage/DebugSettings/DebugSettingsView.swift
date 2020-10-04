//
//  DebugSettingsView.swift
//  rasp.guap
//
//  Created by Кирилл on 04.10.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit

class DebugSettingsView: UIStackView {
	let textField = PocketTextField(frame: .zero)
	let oldimetable = AppSettingsBlock(title: "Старое расписание")
	required init(){
		super.init(frame: .zero)
		self.addArrangedSubview(textField)
		self.addArrangedSubview(oldimetable)
	}
	
	required init(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
