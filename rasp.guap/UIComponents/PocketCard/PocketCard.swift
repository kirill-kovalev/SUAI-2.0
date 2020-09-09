//
//  PocketCard.swift
//  rasp.guap
//
//  Created by Кирилл on 09.09.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit

class PocketCard: UIView {
	let image : UIImageView = {
		let image = UIImageView(frame: .zero)
		image.image = Asset.AppImages.pocketpocketLogo.image
		image.layer.masksToBounds = true
		image.layer.cornerRadius = 10
		image.contentMode = .scaleAspectFill
		return image
	}()
	
	required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
	init(){
		super.init(frame: .zero)
		self.backgroundColor = .red
		self.layer.cornerRadius = 10
		
	}
	private func addViews(){
		
	}
	private func setupConstraints(){
		self.snp.makeConstraints { (make) in
			make.width.equalTo(self.snp.height).multipliedBy(320).dividedBy(190)
		}
		self.image.snp.makeConstraints { (make) in
			make.top.left.right.bottom.equalToSuperview()
		}
	}
}
