//
//  FeedTabView.swift
//  rasp.guap
//
//  Created by Кирилл on 12.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit

class FeedTabView: TabBarPageView {
       
    let sourceSelector = SwitchSelector(frame: .zero)
    
    required init() {
        super.init()
        addViews()
        setupConstraints()
    }
    func addViews(){
        self.header.addSubview(sourceSelector)
    }
    func setupConstraints(){
        sourceSelector.snp.makeConstraints { (make) in
            make.top.equalTo(self.title.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }      
    }
    
    required init?(coder: NSCoder) {
        super.init()
    }
}
