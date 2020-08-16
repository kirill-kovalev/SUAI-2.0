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
    
    
    
    required init() {
        super.init()
        addViews()
        setupConstraints()
        
        
        
        
    }
    
    private func addViews(){
        self.addSubview(pocketDiv)
        pocketDiv.addSubview(loadingIndicator)
        self.addHeaderButton(selectButton)
    }
    private func setupConstraints(){
        pocketDiv.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
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
