//
//  PocketServiceListItem.swift
//  rasp.guap
//
//  Created by Кирилл on 11.09.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit

class PocketServiceListItem: UILabel {
	private var _isAvailable:Bool = false
	var isAvailable:Bool {
		set{
			self._isAvailable = newValue
			if newValue{
				image.tintColor = Asset.PocketColors.pocketGreen.color
				image.image = Asset.SystemIcons.checkCircle.image.withRenderingMode(.alwaysTemplate)
			}else{
				image.tintColor = Asset.PocketColors.pocketError.color
				image.image = Asset.SystemIcons.cancelCircle.image.withRenderingMode(.alwaysTemplate)
			}
		}
		get{
			return self._isAvailable
		}
	}
	let image:UIImageView = {
		let v = UIImageView(frame: .zero)
		v.contentMode = .scaleAspectFit
		v.tintColor = Asset.PocketColors.pocketError.color
		v.image = Asset.SystemIcons.cancelCircle.image.withRenderingMode(.alwaysTemplate)
		return v
	}()
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.font = FontFamily.SFProDisplay.regular.font(size: 14)
		self.addSubview(image)
		image.snp.makeConstraints { (make) in
			make.top.right.bottom.height.equalToSuperview()
			make.width.equalTo(image.snp.height)
			make.height.equalTo(24)
		}
	}
	convenience init(_ title:String,_ isAvailble:Bool){
		self.init(frame:.zero)
		self.text = title
		self.isAvailable = isAvailble
	}
	
	required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
