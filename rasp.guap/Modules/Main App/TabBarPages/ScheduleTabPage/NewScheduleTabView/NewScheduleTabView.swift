//
//  FeedTabView.swift
//  rasp.guap
//
//  Created by Кирилл on 12.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit

class NewScheduleTabView:TabBarPageView{
    

    let selectButton:Button = {
        let btn = Button(frame: .zero)
        btn.setImage(Asset.SystemIcons.scheduleFilter.image.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.imageView?.tintColor = Asset.PocketColors.pocketGray.color
        return btn
    }()
    
    let dayLabel:UILabel = {
        let label = UILabel(frame: .zero)
        label.font = FontFamily.SFProDisplay.semibold.font(size: 14)
        label.textColor = Asset.PocketColors.pocketGray.color
        label.text = "Понедельник"
        return label
    }()
    
	let stack:UIStackView = {
		let s = UIStackView(frame:.zero)
		s.axis = .vertical
		s.spacing = 8
		return s
	}()
	
	
	
    required init() {
        super.init()
        addViews()
        setupConstraints()
        
    }
    
    private func addViews(){
        self.addHeaderButton(selectButton)
        self.addSubview(stack)
    }
    private func setupConstraints(){
		selectButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(24)
            make.centerY.equalTo(title)
        }
		stack.snp.makeConstraints { (make) in
			make.top.left.right.bottom.equalTo(safeAreaLayoutGuide)
		}
    }
    
  
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
