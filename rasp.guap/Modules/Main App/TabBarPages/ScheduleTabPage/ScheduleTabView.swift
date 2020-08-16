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
    let loadingIndicator:UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .gray)
        indicator.color = Asset.PocketColors.pocketGray.color
        indicator.hidesWhenStopped = true
        indicator.startAnimating()
        return indicator
    }()
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
    
    
    
    
    required init() {
        super.init()
        addViews()
        setupConstraints()
        
    }
    
    private func addViews(){
        self.addSubview(pocketDiv)
        pocketDiv.addSubview(loadingIndicator)
        self.addHeaderButton(selectButton)
        self.addSubview(dayLabel)
        self.addSubview(todayButton)
    }
    private func setupConstraints(){
        dayLabel.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview().offset(10)
            make.right.lessThanOrEqualToSuperview()
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
        loadingIndicator.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.top.greaterThanOrEqualToSuperview().offset(50)
            make.bottom.lessThanOrEqualToSuperview().inset(50)
        }
        selectButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(24)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
