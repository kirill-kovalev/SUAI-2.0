//
//  ServiceSettingsView.swift
//  rasp.guap
//
//  Created by Кирилл on 03.09.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import Foundation
import UIKit
import MBRadioButton

class ServiceSettingsView: View {
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
		let tf = PocketDropdownField(frame: .zero)
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
	
	lazy var loadingIndidcator:PocketActivityIndicatorView = {
		let indicator = PocketActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
		indicator.color = Asset.PocketColors.accent.color
		indicator.isHidden = true
		indicator.stopAnimating()
		return indicator
	}()
	
	lazy var content:UIStackView = {
		let stack = UIStackView(frame: .zero)
		stack.axis = .vertical
		stack.spacing = 12
		return stack
	}()
	
	
	required init() {
		super.init()
		addViews()
		setupConstraints()
	}
	func addViews(){
		self.addSubview(content)
		content.addArrangedSubview(groupLabel)
		content.addArrangedSubview(groupSelector)
		content.addArrangedSubview(startscreenLabel)
		content.addArrangedSubview(startScreenSelector)
		content.addArrangedSubview(buildingLabel)
		content.addArrangedSubview(buildingSelector)
		
		
		
		self.addSubview(loadingIndidcator)
	}
	func setupConstraints(){
		content.snp.makeConstraints { (make) in
			make.top.left.right.bottom.equalToSuperview()
		}
		loadingIndidcator.snp.makeConstraints { (make) in
			make.height.width.equalTo(50)
			make.center.equalToSuperview()
		}
				
	}
}
