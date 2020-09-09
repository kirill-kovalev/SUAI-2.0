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
		return label
	}()
	let image:UIImageView = {
		let image = UIImageView(frame: .zero)
		image.image = Asset.AppImages.launchScreen.image
		image.contentMode = .scaleAspectFill
		return image
	}()
	
	
	required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
	required init() {
		super.init()
		self.addSubview(image)
		self.addSubview(label)
		image.snp.makeConstraints{$0.bottom.left.top.right.equalToSuperview()}
		label.snp.makeConstraints { (make) in
			make.centerX.equalToSuperview()
			make.bottom.lessThanOrEqualToSuperview().inset(30)
			make.left.greaterThanOrEqualToSuperview()
			make.right.lessThanOrEqualToSuperview()
		}
	}
	
	
}
