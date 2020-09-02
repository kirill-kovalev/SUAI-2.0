//
//  RocketUserView.swift
//  rasp.guap
//
//  Created by Кирилл on 02.09.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit

class RocketUserView:UIView{
    let avatar = PocketUserAvatar()
    let username:UILabel = {
        let label = UILabel(frame: .zero)
        label.font = FontFamily.SFProDisplay.regular.font(size: 14)
        label.textColor = Asset.PocketColors.pocketBlack.color
        return label
    }()
    let rocketCount:UILabel = {
        let label = UILabel(frame: .zero)
        label.font = FontFamily.SFProDisplay.regular.font(size: 12)
        label.textColor = Asset.PocketColors.pocketGray.color
        return label
    }()
    let rocketImage:UIImageView = {
        let image = UIImageView(image: Asset.AppImages.rocket.image.withRenderingMode(.alwaysTemplate))
        image.tintColor = Asset.PocketColors.pocketGray.color
        return image
    }()
    init() {
        super.init(frame:.zero)
        addSubview(avatar)
        addSubview(username)
        addSubview(rocketCount)
        addSubview(rocketImage)
        avatar.snp.makeConstraints { (make) in
            make.top.left.greaterThanOrEqualToSuperview()
            make.right.lessThanOrEqualToSuperview()
            make.size.equalTo(CGSize(width: 56, height: 56))
        }
        username.snp.makeConstraints { (make) in
            make.left.greaterThanOrEqualToSuperview()
            make.right.lessThanOrEqualToSuperview()
            make.top.equalTo(avatar.snp.bottom).offset(6)
        }
        rocketCount.snp.makeConstraints { (make) in
            make.left.greaterThanOrEqualToSuperview()
            make.right.lessThanOrEqualToSuperview()
            make.top.equalTo(username.snp.bottom).offset(6)
        }
        rocketImage.snp.makeConstraints { (make) in
            make.centerY.equalTo(rocketCount)
            make.left.equalTo(rocketCount.snp.right).offset(4)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
