//
//  PocketDropdownField.swift
//  rasp.guap
//
//  Created by Кирилл on 04.10.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit

class PocketDropdownView:UIView{
	let image = UIImageView(image: Asset.SystemIcons.searchDropdown.image.withRenderingMode(.alwaysTemplate))
	init() {
		super.init(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
		
		image.tintColor = Asset.PocketColors.pocketGray.color
		self.addSubview(image)
		image.snp.makeConstraints { make in
			make.width.height.equalTo(25)
			make.centerY.equalToSuperview()
			make.right.equalToSuperview().inset(8)
			make.left.equalToSuperview()
		}
	}
	
	required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

class PocketDropdownField: PocketTextField {
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.rightViewMode = .always
		self.rightView = PocketDropdownView()
	}
	
	required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
