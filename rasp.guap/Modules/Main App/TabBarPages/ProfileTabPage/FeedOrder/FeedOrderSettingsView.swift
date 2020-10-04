//
//  FeedOrderSettingsView.swift
//  rasp.guap
//
//  Created by Кирилл on 04.10.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit

class FeedOrderSettingsView : View{
	
	let headerBlock = PocketDivView(content: FeedOrderSettingsHeader())
	
	let stack:UIStackView = {
		let stack = UIStackView(frame: .zero)
		stack.axis = .vertical
		stack.spacing = 8
		return stack
	}()
	lazy var stackContainer = PocketDivView(content: stack)
	let submitButton:PocketLongActionButton = {
		let btn = PocketLongActionButton(frame: .zero)
		btn.setTitle("Сохранить изменения", for: .normal)
		btn.setTitleColor(Asset.PocketColors.accent.color, for: .normal)
		btn.setTitleColor(Asset.PocketColors.pocketGray.color, for: .disabled)
		return btn
	}()
	
	required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
	required init() {
		super.init()
		addViews()
		setupConstraints()
	}
	func addViews(){
		self.addSubview(headerBlock)
		self.addSubview(stackContainer)
		self.addSubview(submitButton)
	}
	func setupConstraints(){
		headerBlock.snp.makeConstraints { (make) in
			make.top.left.right.equalToSuperview()
		}
		stackContainer.snp.makeConstraints { (make) in
			make.top.equalTo(headerBlock.snp.bottom).offset(12)
			make.left.right.equalToSuperview()
		}
		submitButton.snp.makeConstraints { (make) in
			make.top.equalTo(stackContainer.snp.bottom).offset(12)
			make.left.right.equalToSuperview()
			make.height.equalTo(45)
			make.bottom.equalToSuperview()
		}
	}
	
	
	
}
