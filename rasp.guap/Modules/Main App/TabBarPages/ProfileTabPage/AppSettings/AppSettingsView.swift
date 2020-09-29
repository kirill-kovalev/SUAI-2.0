//
//  AppSettingsView.swift
//  rasp.guap
//
//  Created by Кирилл on 28.09.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit

class AppSettingsView:View{
	
	lazy var content:UIStackView = {
		let stack = UIStackView(frame: .zero)
		stack.axis = .vertical
		stack.spacing = 12
		return stack
	}()
	
	lazy var clearCacheBtn:PocketButton = {
		let btn = PocketButton(frame: .zero)
		btn.setTitle("Очистить кэш", for: .normal)
		btn.setTitleColor(Asset.PocketColors.pocketDarkestBlue.color, for: .normal)
		return btn
	}()
	
	lazy var deadlineNotifications = AppSettingsBlock(title: "Уведомления об открытых дедлайнах")
	lazy var timetableNotifications = AppSettingsBlock(title: "Уведомления о занятиях")
	
	required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
	required init() {
		super.init()
		addViews()
		setupConstraints()
	}
	func addViews(){
		self.addSubview(content)
		content.addArrangedSubview(deadlineNotifications)
		content.addArrangedSubview(timetableNotifications)
		
		content.addArrangedSubview(clearCacheBtn)
	}
	
	func setupConstraints(){
		content.snp.makeConstraints { (make) in
			make.top.left.right.bottom.equalToSuperview()
		}				
	}
}

class AppSettingsBlock :UIStackView{
	
	func labelGenerator(title:String)->UILabel{
        let label = UILabel(frame: .zero)
        label.font = FontFamily.SFProDisplay.regular.font(size: 14)
        label.textColor = Asset.PocketColors.pocketBlack.color
        label.text = title
        return label
    }
	let toggle:UISwitch = {
		let view = UISwitch(frame: .zero)
		view.onTintColor = Asset.PocketColors.accent.color
		view.isOn = true
		return view
	}()
	
	lazy var label = labelGenerator(title: "")
	
	required init(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
	init(title:String) {
		super.init(frame:.zero)
		self.axis = .horizontal
		self.distribution = .equalCentering
		self.addArrangedSubview(label)
		self.addArrangedSubview(toggle)
		label.text = title
	}
}
