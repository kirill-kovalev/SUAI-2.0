//
//  TutorialPageTemplate.swift
//  rasp.guap
//
//  Created by Кирилл on 06.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit


class TutorialPageView:View{
    
    // MARK: - Views
    let title:UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .center
        label.font = FontFamily.TTCommons.demiBold.font(size: 22)
        return label
    }()
    
    let text:UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .center
        label.textColor = Asset.PocketColors.pocketGray.color
        label.numberOfLines = 3
        label.font = FontFamily.TTCommons.regular.font(size: 18)
        return label
    }()
    
    

    // MARK: - View setup
    
    func addViews(){
        self.addSubview(title)
        self.addSubview(text)
    }
    func setupConstraints(){
        
        title.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(self.snp.bottom).multipliedBy(0.8)
        }
        
        text.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(title.snp.bottom).offset(10)
            make.bottom.lessThanOrEqualToSuperview()
            make.leading.trailing.equalToSuperview().inset(10)
       }

    }
    
}
