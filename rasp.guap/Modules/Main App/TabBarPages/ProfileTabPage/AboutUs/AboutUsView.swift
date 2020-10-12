//
//  AboutUsView.swift
//  rasp.guap
//
//  Created by Кирилл on 04.10.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit

class AboutUsView: View {
	let image: UIImageView = {
		let view = UIImageView(frame: .zero)
		view.layer.masksToBounds = true
		view.layer.cornerRadius = 10
		view.image = UIImage(named: "AppIconLight")
		return view
	}()
	let title: UILabel = {
		let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
		
		let label = UILabel(frame: .zero)
		label.text = "Версия \(appVersion ?? "1.0")"
		label.textColor = Asset.PocketColors.pocketBlack.color
		label.font = FontFamily.SFProDisplay.regular.font(size: 14)
		return label
	}()
	let vkButton: Button = {
		let label = Button(frame: .zero)
		label.setTitle("Группа ВКонтакте", for: .normal)
		label.setTitleColor(Asset.PocketColors.accent.color, for: .normal)
		label.titleLabel?.font = FontFamily.SFProDisplay.regular.font(size: 14)
		return label
	}()
	
	lazy var imageContainer = PocketScalableContainer(content: image)
	required init() {
		super.init()
		addViews()
		setupConstraints()
	}
	func addViews() {
		self.addSubview(imageContainer)
		self.addSubview(title)
		self.addSubview(vkButton)
	}
	func setupConstraints() {
		imageContainer.snp.makeConstraints { (make) in
			make.top.left.bottom.equalToSuperview()
			make.width.height.equalTo(55)
		}
		title.snp.makeConstraints { (make) in
			make.left.equalTo(imageContainer.snp.right).offset(12)
			make.bottom.equalTo(imageContainer.snp.centerY).offset(-2)
		}
		vkButton.snp.makeConstraints { (make) in
			make.left.equalTo(title)
			make.top.equalTo(imageContainer.snp.centerY).offset(-2)
		}
	}
	
	required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
