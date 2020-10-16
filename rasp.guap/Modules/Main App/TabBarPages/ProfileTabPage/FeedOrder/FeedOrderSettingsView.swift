//
//  FeedOrderSettingsView.swift
//  rasp.guap
//
//  Created by Кирилл on 04.10.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit

class FeedOrderSettingsView: View {
	let headerBlock = PocketDivView(content: FeedOrderSettingsHeader())
	
	let stack: UIStackView = {
		let stack = UIStackView(frame: .zero)
		stack.axis = .vertical
		stack.spacing = 8
		return stack
	}()
	let scroll: UIScrollView = {
		let scroll = UIScrollView(frame: .zero)
		
		return scroll
	}()
	lazy var stackContainer = PocketDivView(content: stack)
	let submitButton: PocketLongActionButton = {
		let btn = PocketLongActionButton(frame: .zero)
		btn.setTitle("Сохранить изменения", for: .normal)
		btn.setTitleColor(Asset.PocketColors.accent.color, for: .normal)
		btn.setTitleColor(Asset.PocketColors.pocketGray.color, for: .disabled)
		return btn
	}()
	let activityIndicator = PocketActivityIndicatorView(frame: CGRect(x: 30, y: 30, width: 40, height: 40))
	
	required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
	required init() {
		super.init()
		addViews()
		setupConstraints()
		activityIndicator.startAnimating()
	}
	func addViews() {
		self.addSubview(scroll)
		scroll.addSubview(headerBlock)
		scroll.addSubview(stackContainer)
		self.addSubview(submitButton)
		stack.addArrangedSubview(activityIndicator)
	}
	func setupConstraints() {
		scroll.snp.makeConstraints { (make) in
			make.top.equalToSuperview().offset(-12)
			make.left.right.equalToSuperview()
			make.height.greaterThanOrEqualTo(scroll.contentLayoutGuide).priority(.medium)
		}
		headerBlock.snp.makeConstraints { (make) in
			make.top.equalTo(scroll.contentLayoutGuide).offset(12)
			make.left.right.equalTo(scroll.frameLayoutGuide)
		}
		stackContainer.snp.makeConstraints { (make) in
			make.top.equalTo(headerBlock.snp.bottom).offset(12)
			make.bottom.equalTo(scroll.contentLayoutGuide).inset(12)
			make.left.right.equalTo(scroll.frameLayoutGuide)
		}
		submitButton.snp.makeConstraints { (make) in
			make.top.equalTo(scroll.snp.bottom).offset(12)
			make.left.right.equalToSuperview()
			make.height.equalTo(45)
			make.bottom.equalToSuperview()
		}
		activityIndicator.snp.makeConstraints { (make) in
			make.height.width.equalTo(40)
		}
	}
	
}
