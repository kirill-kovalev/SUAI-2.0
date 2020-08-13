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
    
    required init() {
        super.init()
        self.addSubview(pocketDiv)
        
        pocketDiv.snp.makeConstraints { (make) in
            make.top.equalTo(self.header.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().inset(10)
        }
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
