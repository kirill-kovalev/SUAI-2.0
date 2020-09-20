//
//  PocketSnackView.swift
//  rasp.guap
//
//  Created by Кирилл on 20.09.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit

class  PocketSnackView: View {
	
	let icon:UIImageView = {
		let view = UIImageView(frame: .zero)
		view.contentMode = .scaleAspectFit
		view.image = Asset.SystemIcons.checkCircle.image
		return view
	}()
	
	let textLabel:UILabel = {
		let view = UILabel(frame: .zero)
		view.numberOfLines = 0
		return view
	}()
	
	required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
	required init() {
		super.init()
		addViews()
		setupConstraints()
	}
	func addViews(){
		self.addSubview(icon)
		self.addSubview(textLabel)
	}
	func setupConstraints(){
		icon.snp.makeConstraints { (make) in
			make.left.equalToSuperview()
			make.centerY.equalToSuperview()
			make.width.height.equalTo(24)
			make.top.greaterThanOrEqualToSuperview()
			make.bottom.lessThanOrEqualToSuperview()
		}
		textLabel.snp.makeConstraints { (make) in
			make.left.equalTo(icon.snp.right).offset(10)
			make.right.equalToSuperview()
			make.top.greaterThanOrEqualToSuperview()
			make.bottom.lessThanOrEqualToSuperview()
			make.centerY.equalToSuperview()
		}
	}
	
}
