//
//  TutuorialScreenView.swift
//  rasp.guap
//
//  Created by Кирилл on 31.07.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit

class TutorialScreenView: MainView, UIScrollViewDelegate {
    
    
    let pagedView:PagedView = {
        let pages =  PagedView();
        pages.pageControl.currentPageIndicatorTintColor =  Asset.PocketColors.accent.color
        pages.pageControl.pageIndicatorTintColor = Asset.PocketColors.pocketAqua.color
        return pages
    }()
    let elipse = TutorialScreenView.BackgroundElipse()
//    let backButton:Button = {
//        let btn = Button(frame: .zero);
//        btn.setTitle("Назад", for: .normal)
//        return btn
//    }()

    func addViews() {
        
        self.addSubview(elipse)
        self.addSubview(pagedView)
//        self.addSubview(backButton)
//        for i in 0..<colors.count {
//            let v = UIView(frame: .zero)
//            v.backgroundColor = colors[i].withAlphaComponent(0.05)
//            pagedView.addSubview(v)
//        }
    }
    
    var colors:[UIColor] = [UIColor.red, UIColor.green, UIColor.blue, UIColor.yellow , .brown ,.magenta]
    
    func setupConstraints() {
        self.pagedView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(safeAreaLayoutGuide)
            make.top.equalTo(self.snp.top)
        }
        self.elipse.snp.makeConstraints { (make) in
            make.centerX.centerY.equalToSuperview()
            make.width.equalTo(self.snp.height).multipliedBy(1.6)
            make.height.equalTo(self.snp.width).multipliedBy(1.6)
        }
//        self.backButton.snp.makeConstraints { (make) in
//            make.top.left.equalToSuperview()
//            make.height.width.equalTo(150)
//        }
        
    }
    
    
    required init() {
        super.init()
        addViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}


