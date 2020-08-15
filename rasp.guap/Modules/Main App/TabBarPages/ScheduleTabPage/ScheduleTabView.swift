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
    
    required init() {
        super.init()
        self.addSubview(pocketDiv)
        pocketDiv.addSubview(loadingIndicator)
        
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
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
