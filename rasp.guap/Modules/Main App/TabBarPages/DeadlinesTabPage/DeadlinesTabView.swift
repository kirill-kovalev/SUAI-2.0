//
//  FeedTabView.swift
//  rasp.guap
//
//  Created by Кирилл on 12.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit

class DeadlinesTabView: TabBarPageView {
    private let selectorStack: UIStackView = {
        let s = UIStackView(frame: .zero)
        s.axis = .horizontal
        s.spacing = 6
        return s
    }()
    
    let addButton: Button = {
        let btn = Button(frame: .zero)
        btn.setImage(Asset.SystemIcons.add.image.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.imageView?.tintColor = Asset.PocketColors.pocketGray.color
        return btn
    }()
	let scroll: UIScrollView = {
		let s = UIScrollView(frame: .zero)
		s.showsHorizontalScrollIndicator = false
		return s
	}()
	let deadlineListSelector: SwitchSelector = {
		let s = SwitchSelector(frame: .zero)
		
		return s
	}()
    
    let pocketDiv = PocketDivView()
    
	let placeholder = PocketDivPlaceholder(title: "Дедлайнов нет!", subtitle: "", image: Asset.AppImages.TabBarImages.deadlines.image, tint: Asset.PocketColors.pocketError.color) 
    lazy var  placeholderContainer = PocketScalableContainer(content: placeholder)
    required init() {
        super.init()
        addViews()
        setupConstraints()
    }
    func addViews() {
        self.header.addSubview(selectorStack)
		self.header.addSubview(deadlineListSelector)
        self.addHeaderButton(addButton)
		self.addSubview(scroll)
		self.scroll.addSubview(pocketDiv)
		self.pocketDiv.addSubview(placeholderContainer)
    }
    func setupConstraints() {
		deadlineListSelector.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().inset(10)
            make.top.equalTo(self.title.snp.bottom).offset(10)
			make.bottom.equalToSuperview().inset(6)
        }
		scroll.snp.makeConstraints { (make) in
			make.top.equalToSuperview()
			make.left.right.equalToSuperview()
			make.bottom.equalTo(safeAreaLayoutGuide)
		}
        pocketDiv.snp.makeConstraints { (make) in
			make.top.equalTo(scroll.contentLayoutGuide).offset(20)
			make.centerX.equalToSuperview()
            make.width.equalToSuperview().inset(10)
			make.bottom.lessThanOrEqualTo(scroll.contentLayoutGuide).inset(12)
        }
		placeholderContainer.snp.makeConstraints { (make) in
			make.top.left.right.bottom.equalToSuperview()
		}
		
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
