//
//  FeedTabView.swift
//  rasp.guap
//
//  Created by Кирилл on 12.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit

class DeadlinesTabView:TabBarPageView {
        
    private let selectorStack:UIStackView = {
        let s = UIStackView(frame: .zero)
        s.axis = .horizontal
        s.spacing = 6
        return s
    }()
    
    let addButton:Button = {
        let btn = Button(frame: .zero)
        btn.setImage(Asset.SystemIcons.add.image.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.imageView?.tintColor = Asset.PocketColors.pocketGray.color
        return btn
    }()
	let deadlineListSelector:SwitchSelector = {
		let s = SwitchSelector(frame: .zero)
		
		return s
	}()
    
    let pocketDiv = PocketDivView()
    
    
    
    required init() {
        super.init()
        addViews()
        setupConstraints()
    }
    func addViews(){
        self.header.addSubview(selectorStack)
		self.header.addSubview(deadlineListSelector)
        self.addHeaderButton(addButton)
        self.addSubview(pocketDiv)
    }
    func setupConstraints(){
        pocketDiv.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(16)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().inset(10)
            make.bottom.lessThanOrEqualToSuperview()
        }
		deadlineListSelector.snp.makeConstraints { (make) in
            make.top.equalTo(title.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
