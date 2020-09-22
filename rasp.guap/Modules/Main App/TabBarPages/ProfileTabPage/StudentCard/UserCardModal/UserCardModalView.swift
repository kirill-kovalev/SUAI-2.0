//
//  UserCardModalView.swift
//  rasp.guap
//
//  Created by Кирилл on 09.09.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit

class UserCardModalView: UIView {
	
	let card = PocketCard()
	
	let title:UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "Все нужное - в кармане!"
        label.font = FontFamily.TTCommons.bold.font(size: 21)
        label.textColor = Asset.PocketColors.pocketBlack.color
        return label
    }()
    let subtitle:UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "SUAI ID позволяет собирать в SUAI Pocket информацию из других сервисов, первым из которых стал pro.guap, расширяя имеющуюся функциональность"
        label.font = FontFamily.SFProDisplay.semibold.font(size: 14)
        label.textColor = Asset.PocketColors.pocketGray.color
		label.numberOfLines = 0
		label.textAlignment = .center
        return label
    }()
    let serviceListLabel:UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "Доступные сервисы"
        label.font = FontFamily.SFProDisplay.semibold.font(size: 14)
        label.textColor = Asset.PocketColors.pocketBlack.color
        return label
    }()
	let serviceStack:UIStackView = {
		let stack = UIStackView(frame: .zero)
		stack.axis = .vertical
		stack.spacing = 12
		return stack
	}()
	let scroll:UIScrollView = {
		let scroll = UIScrollView(frame: .zero)
		
		return scroll
	}()
	
	required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
	required init(){
		super.init(frame:.zero)
		addViews()
		setupConstraints()
	}
	
	private func addViews(){
		self.addSubview(card)
		addSubview(title)
        addSubview(subtitle)
        addSubview(serviceListLabel)
		addSubview(scroll)
		scroll.addSubview(serviceStack)
	}
	private func setupConstraints(){
		card.snp.makeConstraints { (make) in
			make.top.equalToSuperview()
			make.left.right.equalToSuperview()
			make.bottom.lessThanOrEqualToSuperview()
		}
		title.snp.makeConstraints { (make) in
			make.top.equalTo(card.snp.bottom).offset(12)
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
        serviceListLabel.snp.makeConstraints { (make) in
            make.top.equalTo(subtitle.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.left.greaterThanOrEqualToSuperview().offset(10)
            make.right.lessThanOrEqualToSuperview().inset(10)
			
        }
		scroll.snp.makeConstraints { (make) in
			make.top.equalTo(serviceListLabel.snp.bottom).offset(12)
			make.left.right.equalToSuperview()
			make.bottom.equalToSuperview()
			make.height.greaterThanOrEqualTo(serviceStack).priority(.medium)
		}
		serviceStack.snp.makeConstraints { (make) in
			make.left.right.equalTo(scroll.frameLayoutGuide)
			make.top.bottom.equalTo(scroll.contentLayoutGuide)
		}
	}
}
