//
//  SecondPageView.swift
//  rasp.guap
//
//  Created by Кирилл on 06.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit

class SecondPageView: TutorialPageView{
    
    // MARK: - Views
    
    let imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let div:UIView = {
        let div = UIView(frame: .zero)
        return div
    }()
    
    // MARK: - View setup
    
    required init() {
        super.init()
        setupUI()
        addViews()
        setupConstraints()
    }
    
    override func addViews() {
        super.addViews()
        self.addSubview(imageView)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        imageView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            let imageHeight:CGFloat = imageView.image?.size.height ?? 1
            let imageWidth:CGFloat = imageView.image?.size.width ?? 0
            make.width.equalTo(imageView.snp.height).multipliedBy(imageWidth/imageHeight)
            make.height.lessThanOrEqualTo(imageHeight)
            make.size.lessThanOrEqualToSuperview()
            make.width.height.lessThanOrEqualToSuperview().multipliedBy(0.8).priority(.high)
        }
    }
    
    private func setupUI(){
        self.title.text = "Новости"
        self.text.text = "Будь в курсе всех событий \nуниверситета и секций"
        self.imageView.image = Asset.AppImages.TutorialPreview.news.image
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
