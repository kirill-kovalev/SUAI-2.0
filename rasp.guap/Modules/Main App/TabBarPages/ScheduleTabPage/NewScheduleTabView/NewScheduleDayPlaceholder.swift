//
//  NewScheduleDayPlaceholder.swift
//  rasp.guap
//
//  Created by Кирилл on 05.10.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit

class NewScheduleDayPlaceholder: UIView {
	let titleLabel: UILabel = {
		let label = UILabel(frame: .zero)
		label.font = FontFamily.SFProDisplay.semibold.font(size: 14)
		label.textColor = Asset.PocketColors.pocketBlack.color
		label.textAlignment = .center
		label.numberOfLines = 0
		label.text = "Понедельник, пар нет!"
		return label
	}()
	private let subtitleLabel: UILabel = {
		let label = UILabel(frame: .zero)
		label.font = FontFamily.SFProDisplay.semibold.font(size: 12)
		label.textColor = Asset.PocketColors.pocketGray.color
		label.textAlignment = .center
		label.numberOfLines = 0
		label.text = "Можно спать спокойно!"
		return label
	}()
	private let imageView: UIImageView = {
		let imageView = UIImageView(frame: .zero)
		imageView.tintColor = Asset.PocketColors.accent.color
		imageView.image = Asset.AppImages.DeadlineStateImages.calendar.image.withRenderingMode(.alwaysTemplate)
		return imageView
	}()
	
	init() {
		super.init(frame: .zero)
		addViews()
		setupConstraints()
	}
	
	required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
	
	private func addViews() {
		self.addSubview(titleLabel)
		self.addSubview(subtitleLabel)
		self.addSubview(imageView)
	}
	
	private func setupConstraints() {
		imageView.snp.makeConstraints { (make) in
			make.left.equalToSuperview()
			make.top.greaterThanOrEqualToSuperview().offset(4)
			make.bottom.lessThanOrEqualToSuperview().inset(4)
			make.height.width.equalTo(35)
		}
		titleLabel.snp.makeConstraints { (make) in
			make.top.equalToSuperview().offset(4)
			make.bottom.equalTo(imageView.snp.centerY)
			make.left.equalTo(imageView.snp.right).offset(8)
		}
		subtitleLabel.snp.makeConstraints { (make) in
			make.bottom.equalToSuperview().inset(4)
			make.top.equalTo(imageView.snp.centerY)
			make.left.equalTo(titleLabel)
		}
	}
}
