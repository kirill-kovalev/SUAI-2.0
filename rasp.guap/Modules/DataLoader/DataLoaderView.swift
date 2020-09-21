//
//  DataLoaderView.swift
//  rasp.guap
//
//  Created by Кирилл on 09.09.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit

class DataLoaderView:View {
	
	let label:UILabel = {
		let label = UILabel(frame: .zero)
		label.numberOfLines = 0
		label.font = FontFamily.TTCommons.demiBold.font(size: 14)
		label.textColor = Asset.PocketColors.pocketGray.color
		return label
	}()
	let image:UIImageView = {
		let image = UIImageView(frame: .zero)
		image.image = Asset.AppImages.launchScreen.image
		image.contentMode = .scaleAspectFill
		return image
	}()
	let reloadButton:Button = {
		let btn = Button(frame: .zero)
		btn.setImage(Asset.SystemIcons.cancelCircle.image, for: .normal)
		btn.isHidden = true
		return btn
	}()
	
	
	required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
	required init() {
		super.init()
		self.addSubview(image)
		self.addSubview(label)
		self.addSubview(reloadButton)
		image.snp.makeConstraints{$0.bottom.left.top.right.equalToSuperview()}
		label.snp.makeConstraints { (make) in
			make.centerX.equalToSuperview()
			make.bottom.lessThanOrEqualToSuperview().inset(40)
			make.left.greaterThanOrEqualToSuperview()
			make.right.lessThanOrEqualToSuperview()
		}
		reloadButton.snp.makeConstraints { (make) in
			make.bottom.equalTo(label.snp.top).inset(15)
			make.centerX.equalToSuperview()
			make.height.width.equalTo(30)
		}
	}
	
	
}
