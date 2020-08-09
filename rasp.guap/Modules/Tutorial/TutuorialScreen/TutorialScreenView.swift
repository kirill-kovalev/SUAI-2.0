//
//  TutuorialScreenView.swift
//  rasp.guap
//
//  Created by Кирилл on 31.07.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit

class TutorialScreenView: View, UIScrollViewDelegate {
    
    
    let pagedView:PagedView = {
        let pages =  PagedView();
        pages.pageControl.currentPageIndicatorTintColor =  Asset.PocketColors.pocketDarkBlue.color
        pages.pageControl.pageIndicatorTintColor = Asset.PocketColors.pocketBlue.color
        return pages
    }()
    let elipse = TutorialScreenView.BackgroundElipse()
    let backButton:Button = {
        let btn = Button(frame: .zero);
        btn.setTitle("Назад", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        return btn
    }()

    func addViews() {
        
        self.addSubview(elipse)
        self.addSubview(pagedView)
        self.addSubview(backButton)

    }
    
    
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
        self.backButton.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview()
            make.height.width.equalTo(0)
        }
        
    }
    
    
    required init() {
        super.init()
        addViews()
        setupConstraints()
        self.backgroundColor = Asset.PocketColors.pocketWhite.color
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}


