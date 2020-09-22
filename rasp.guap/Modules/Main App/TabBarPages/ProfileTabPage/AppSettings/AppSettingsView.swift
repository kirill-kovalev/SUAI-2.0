//
//  AppSettingsView.swift
//  rasp.guap
//
//  Created by Кирилл on 03.09.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import Foundation
import UIKit
import MBRadioButton

class AppSettingsView: View {
	required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
	func labelGenerator(title:String)->UILabel{
        let label = UILabel(frame: .zero)
        label.font = FontFamily.SFProDisplay.regular.font(size: 14)
        label.textColor = Asset.PocketColors.pocketBlack.color
        label.text = title
        return label
    }
	lazy var groupLabel = self.labelGenerator(title:"Группа")
	lazy var startscreenLabel = self.labelGenerator(title:"Начальный экран")
	lazy var buildingLabel = self.labelGenerator(title:"Корпус по умолчанию")
	
	lazy var groupSelector:UITextField = {
		let tf = PocketTextField(frame: .zero)
		
		return tf
	}()
	
	lazy var startScreenSelector:UIStackView = {
		let stack = UIStackView(frame: .zero)
		stack.spacing = 2
		stack.axis = .vertical
		return stack
	}()
	
	lazy var buildingSelector:UIStackView = {
		let stack = UIStackView(frame: .zero)
		stack.spacing = 2
		stack.axis = .vertical
		return stack
	}()
		
	
	
	required init() {
		super.init()
		addViews()
		setupConstraints()
	}
	func addViews(){
		self.addSubview(groupLabel)
		self.addSubview(groupSelector)
		self.addSubview(startscreenLabel)
		self.addSubview(startScreenSelector)
		self.addSubview(buildingLabel)
		self.addSubview(buildingSelector)
		
	}
	func setupConstraints(){
		groupLabel.snp.makeConstraints { $0.top.left.equalToSuperview() }
		groupSelector.snp.makeConstraints { (make) in
			make.left.right.equalToSuperview()
			make.top.equalTo(groupLabel.snp.bottom).offset(12)
		}
		startscreenLabel.snp.makeConstraints { (make) in
			make.left.right.equalToSuperview()
			make.top.equalTo(groupSelector.snp.bottom).offset(12)
		}
		startScreenSelector.snp.makeConstraints { (make) in
			make.left.right.equalToSuperview()
			make.top.equalTo(startscreenLabel.snp.bottom).offset(12)
		}
		buildingLabel.snp.makeConstraints { (make) in
			make.left.right.equalToSuperview()
			make.top.equalTo(startScreenSelector.snp.bottom).offset(12)
		}
		buildingSelector.snp.makeConstraints { (make) in
			make.left.right.equalToSuperview()
			make.top.equalTo(buildingLabel.snp.bottom).offset(12)
			make.bottom.equalToSuperview()
		}
				
	}
}
