//
//  FeedTabView.swift
//  rasp.guap
//
//  Created by Кирилл on 12.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit

class ScheduleTabView:TabBarPageView{
    let pocketDiv = PocketDivView()

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
    let todayButton : Button = {
        let btn = Button(frame: .zero)
        btn.setTitle("Сегодня", for: .normal)
        btn.setTitleColor(Asset.PocketColors.accent.color, for: .normal)
        btn.titleLabel?.font = FontFamily.SFProDisplay.semibold.font(size: 14)
        return btn
    }()
	
	
	let placeholder = PocketDivPlaceholder(title: "Пар нет!", subtitle: "Можно спать спокойно!", image: Asset.AppImages.TabBarImages.schedule.image)
    
    
    
    
    required init() {
        super.init()
        addViews()
        setupConstraints()
        
    }
    
    private func addViews(){
        self.addSubview(pocketDiv)
        self.addHeaderButton(selectButton)
        self.addSubview(dayLabel)
        self.addSubview(todayButton)
        
        pocketDiv.addSubview(placeholder)
    }
    private func setupConstraints(){
        dayLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(2)
            make.right.lessThanOrEqualToSuperview()
			make.left.equalTo(pocketDiv)
        }
        todayButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(dayLabel)
            make.right.equalToSuperview().inset(10)
        }
        pocketDiv.snp.makeConstraints { (make) in
            make.top.equalTo(dayLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().inset(10)
            make.bottom.lessThanOrEqualToSuperview()
        }
		selectButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(24)
            make.centerY.equalTo(title)
        }
		
        placeholder.snp.makeConstraints { (make) in
			make.height.lessThanOrEqualToSuperview()
			make.width.equalToSuperview()
			make.center.equalToSuperview()
        }
    }
    
    func showIndicator(show:Bool){
		if show {
			self.placeholder.startLoading()
		}else{
			self.placeholder.stopLoading()
		}
    }
    func showNoLesson(show:Bool){
        if show {
			self.placeholder.show()
        }else{
            self.placeholder.hide()
        }
        self.placeholder.isHidden = !show
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
