//
//  RockrtModalView.swift
//  rasp.guap
//
//  Created by Кирилл on 31.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit

class RocketModalView: ModalView {
    let image:UIImageView = {
        let img = UIImageView(frame: .zero)
        img.image = Asset.AppImages.stickers.image
        return img
    }()
    let title:UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "Собирай рокеты!"
        label.font = FontFamily.TTCommons.bold.font(size: 21)
        label.textColor = Asset.PocketColors.pocketBlack.color
        return label
    }()
    let subtitle:UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "Пользуйся сервисом и получай рокеты! Лучших ждут стикеры еженедельно!"
        label.font = FontFamily.SFProDisplay.semibold.font(size: 14)
        label.textColor = Asset.PocketColors.pocketGray.color
		label.numberOfLines = 0
		label.textAlignment = .center
        return label
    }()
    let topTitle:UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "Топ-3 недели"
        label.font = FontFamily.SFProDisplay.semibold.font(size: 14)
        label.textColor = Asset.PocketColors.pocketBlack.color
        return label
    }()
    let stack:UIStackView = {
        let stack = UIStackView(frame: .zero)
        stack.axis = .horizontal
        stack.spacing = 10
        return stack
    }()
    let nextGiveaway:UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "(Следующий розыгрышь через дней)"
		label.font = FontFamily.SFProDisplay.semibold.font(size: 14)
        label.textColor = Asset.PocketColors.pocketGray.color
        return label
    }()
    required init() {
        super.init()
        self.backgroundColor = .clear
        addViews()
        setupConstraints()
    }
    
    func addViews(){
        addSubview(image)
        addSubview(title)
        addSubview(subtitle)
        addSubview(topTitle)
        addSubview(stack)
        addSubview(nextGiveaway)
    }
    func setupConstraints(){
        image.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 128, height: 128))
        }
        title.snp.makeConstraints { (make) in
			make.top.equalTo(image.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
            make.left.greaterThanOrEqualToSuperview().offset(10)
            make.right.lessThanOrEqualToSuperview().inset(10)
        }
        subtitle.snp.makeConstraints { (make) in
			make.top.equalTo(title.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.left.greaterThanOrEqualToSuperview().offset(10)
            make.right.lessThanOrEqualToSuperview().inset(10)
        }
        topTitle.snp.makeConstraints { (make) in
            make.top.equalTo(subtitle.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.left.greaterThanOrEqualToSuperview().offset(10)
            make.right.lessThanOrEqualToSuperview().inset(10)
        }
        stack.snp.makeConstraints { (make) in
            make.top.equalTo(topTitle.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
            make.left.greaterThanOrEqualToSuperview().offset(10)
            make.right.lessThanOrEqualToSuperview().inset(10)
        }
        nextGiveaway.snp.makeConstraints { (make) in
            make.top.equalTo(stack.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
			make.bottom.equalToSuperview().inset(8)
            make.left.greaterThanOrEqualToSuperview().offset(10)
            make.right.lessThanOrEqualToSuperview().inset(10)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
