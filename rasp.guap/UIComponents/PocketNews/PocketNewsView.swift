//
//  PocketNewsView.swift
//  rasp.guap
//
//  Created by Кирилл on 07.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit

class PocketNewsView: UIView {
    
    // MARK: - views
    
    let authorLabel:UILabel = {
        let label = UILabel(frame: .zero)
        label.font = FontFamily.SFProDisplay.regular.font(size: 14)
        label.textColor = Asset.PocketColors.pocketDarkBlue.color
        label.text = "ГУАП | SUAI"
        return label
    }()
    
    let titleLabel:UILabel = {
        let label = UILabel(frame: .zero)
        label.font = FontFamily.SFProDisplay.semibold.font(size: 15)
        label.textColor = Asset.PocketColors.pocketBlack.color
        label.numberOfLines = 2
        label.text = "Приходи на день абитуриента и выбирай свое будущее!"
        return label
    }()
    
    let imageView:UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 87, height: 87))
        imageView.image = Asset.AppImages.photoPlaceholder.image
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let likeIcon:UIImageView = {
        let icon = UIImageView(image: Asset.SystemIcons.likes.image )
        icon.image = icon.image?.withRenderingMode(.alwaysTemplate)
        icon.tintColor = Asset.PocketColors.pocketGray.color
        return icon
    }()
    
    let likeLabel:UILabel = {
        let label = UILabel(frame: .zero)
        label.font = FontFamily.SFProDisplay.regular.font(size: 14)
        label.textColor = Asset.PocketColors.pocketGray.color
        label.text = "205"
        return label
    }()
    
    let datetimeLabel:UILabel = {
        let label = UILabel(frame: .zero)
        label.font = FontFamily.SFProDisplay.regular.font(size: 14)
        label.textColor = Asset.PocketColors.pocketGray.color
        label.text = "4 декабря в 12:00"
        return label
    }()
    
    
    
    init() {
        super.init(frame:.zero)
        
        addViews()
        setupConstraints()
    }
    
    private func addViews(){
        
        self.addSubview(authorLabel)
        self.addSubview(titleLabel)
        self.addSubview(imageView)
        
        self.addSubview(likeIcon)
        self.addSubview(likeLabel)
        
        self.addSubview(datetimeLabel)
    }
    
    private func setupConstraints(){
        self.imageView.snp.makeConstraints { (make) in
            make.height.width.equalTo(87)
            make.top.bottom.right.equalToSuperview()
        }
        self.authorLabel.snp.makeConstraints { (make) in
            make.top.equalTo(imageView)
            make.left.equalToSuperview()
            make.right.equalTo(imageView.snp.left).offset(10)
        }
        self.likeIcon.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.bottom.equalTo(imageView)
            make.size.equalTo(CGSize(width: 14, height: 14))
        }
        self.likeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(likeIcon.snp.right).offset(7)
            make.centerY.equalTo(likeIcon)
        }
        self.datetimeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(likeLabel.snp.right).offset(12)
            make.firstBaseline.equalTo(likeLabel.snp.firstBaseline)
            make.right.lessThanOrEqualTo(imageView.snp.left)
        }
        self.titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(authorLabel)
            make.top.equalTo(authorLabel.snp.bottom).offset(7)
            make.right.equalTo(imageView.snp.left).inset(12)
            make.bottom.lessThanOrEqualTo(likeLabel.snp.top)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
}
