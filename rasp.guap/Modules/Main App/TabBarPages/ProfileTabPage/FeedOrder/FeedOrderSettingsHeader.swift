//
//  FeedOrderSettingsHeader.swift
//  rasp.guap
//
//  Created by Кирилл on 04.10.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit

class FeedOrderSettingsHeader: UIStackView {
	let title: UILabel = {
		let label = UILabel(frame: .zero)
		label.text = "Настраивай новости под себя"
		label.numberOfLines = 0
		label.font = FontFamily.TTCommons.demiBold.font(size: 19)
		label.textColor = Asset.PocketColors.pocketBlack.color
		label.layoutMargins.top = 10
		return label
	}()
	let text: UILabel = {
		let label = UILabel(frame: .zero)
		label.text = "В SUAI Pocket размещено большое количество тематических пабликов, но мы прекрасно понимаем, что некоторые из них не нужны.\nПоэтому от них можно легко отказаться, оставив только самые необходимые!"
		label.numberOfLines = 0
		label.font = FontFamily.SFProDisplay.regular.font(size: 13)
		label.textColor = Asset.PocketColors.pocketGray.color
		return label
	}()
	init() {
		super.init(frame: .zero)
		self.axis = .vertical
		self.spacing = 8
		self.addArrangedSubview(title)
		self.addArrangedSubview(text)
	}
	
	required init(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
