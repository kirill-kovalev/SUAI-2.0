//
//  TabBarPageView.swift
//  rasp.guap
//
//  Created by Кирилл on 12.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit

class TabBarPageView : View{
    let header:UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = Asset.PocketColors.headerBackground.color
        return view
    }()
    private let title : UILabel = {
        let label = UILabel(frame: .zero)
        label.font = FontFamily.TTCommons.bold.font(size: 24)
        label.numberOfLines = 1
        label.text = "Title"
        return label
    }()
    
    private func addViews(){
        self.addSubview(header)
        header.addSubview(title)
    }
    private func setupConstraints(){
        header.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top)
            make.bottom.greaterThanOrEqualTo(safeAreaLayoutGuide.snp.top).offset(35)
            make.bottom.lessThanOrEqualTo(safeAreaLayoutGuide.snp.top).offset(65)
            make.left.right.equalToSuperview()
        }
        title.snp.makeConstraints { (make) in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(5)
            make.bottom.lessThanOrEqualToSuperview().inset(10)
            make.centerX.equalToSuperview()
        }
    }
    
    func setTitle(_ title:String) {
        self.title.text = title
    }
    
    required init() {
        super.init()
        self.backgroundColor = Asset.PocketColors.backgroundPage.color
        
        addViews()
        setupConstraints()
    }
    required init?(coder: NSCoder) {
        super.init()
    }
}
