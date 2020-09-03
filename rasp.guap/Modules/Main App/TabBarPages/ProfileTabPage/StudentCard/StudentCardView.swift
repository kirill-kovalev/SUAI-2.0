//
//  StudentCardView.swift
//  rasp.guap
//
//  Created by Кирилл on 03.09.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit

class StudentCardView: View {
	let avatar = PocketUserAvatar()
	let name:UILabel = {
		let label = UILabel(frame: .zero)
		label.font = FontFamily.SFProDisplay.semibold.font(size: 14)
		label.textColor = Asset.PocketColors.pocketBlack.color
		return label
	}()
	let group:UILabel = {
		let label = UILabel(frame: .zero)
		label.font = FontFamily.SFProDisplay.regular.font(size: 14)
		label.textColor = Asset.PocketColors.pocketGray.color
		return label
	}()
	let suaiImage:UIImageView = {
		let image = UIImageView(image: Asset.AppImages.suaiCard.image.withRenderingMode(.alwaysTemplate))
		image.tintColor = Asset.PocketColors.pocketDarkBlue.color
		return image
	}()
	let suai:UILabel = {
		let label = UILabel(frame: .zero)
		label.text = "SUAI ID"
		label.font = FontFamily.SFProDisplay.semibold.font(size: 14)
		label.textColor = Asset.PocketColors.pocketDarkBlue.color
		return label
	}()
	
	required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
	required init() {
		super.init()
		addViews()
		setupConstraints()
		avatar.color = .clear
	}
	
	func addViews(){
		self.addSubview(avatar)
		self.addSubview(name)
		self.addSubview(group)
		self.addSubview(suaiImage)
		self.addSubview(suai)
	}
	func setupConstraints(){
		avatar.snp.makeConstraints { (make) in
			make.top.left.bottom.equalToSuperview()
			make.size.equalTo(CGSize(width: 60, height: 60))
		}
		name.snp.makeConstraints { (make) in
			make.bottom.equalTo(avatar.snp.centerY)
			make.left.equalTo(avatar.snp.right).offset(8)
		}
		group.snp.makeConstraints { (make) in
			make.top.equalTo(avatar.snp.centerY)
			make.left.equalTo(name)
		}
		suai.snp.makeConstraints { (make) in
			make.right.equalToSuperview().offset(-8)
			make.centerY.equalToSuperview()
		}
		suaiImage.snp.makeConstraints { (make) in
			make.right.equalTo(suai.snp.left).offset(-4)
			make.size.equalTo(CGSize(width: 24, height: 24))
			make.centerY.equalTo(suai)
		}
	}

}
