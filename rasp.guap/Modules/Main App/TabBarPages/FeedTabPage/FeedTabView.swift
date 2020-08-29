//
//  FeedTabView.swift
//  rasp.guap
//
//  Created by Кирилл on 12.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit

class FeedTabView: TabBarPageView {
    
//    let contentScroll:UIScrollView = {
//        let s = UIScrollView(frame: .zero)
//        s.bounces = true
//        return s
//    }()
//    let content:UIStackView = {
//        let v = UIStackView(frame: .zero)
//        v.axis = .vertical
//        return v
//    }()
    
    let sourceSelector = SwitchSelector(frame: .zero)
    
    
    
    required init() {
        super.init()
        addViews()
        setupConstraints()
    }
    func addViews(){
        self.header.addSubview(sourceSelector)
        
//        self.addSubview(contentScroll)
//        self.contentScroll.addSubview(content)
       
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
