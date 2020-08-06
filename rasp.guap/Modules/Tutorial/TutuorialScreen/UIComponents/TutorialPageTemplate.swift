//
//  TutorialPageTemplate.swift
//  rasp.guap
//
//  Created by Кирилл on 06.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit


class TutorialPageView:MainView{
    
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
    
    let imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    // MARK: - View setup
    
    func addViews(){
        self.addSubview(title)
        self.addSubview(text)
        self.addSubview(imageView)
    }
    func setupConstraints(){
        imageView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            let imageHeight:CGFloat = imageView.image?.size.height ?? 1
            let imageWidth:CGFloat = imageView.image?.size.width ?? 0
            make.width.equalTo(imageView.snp.height).multipliedBy(imageWidth/imageHeight)
            make.height.lessThanOrEqualTo(imageHeight)
            make.size.lessThanOrEqualToSuperview()
            make.width.height.lessThanOrEqualToSuperview().multipliedBy(0.8).priority(.high)
        }
        
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
