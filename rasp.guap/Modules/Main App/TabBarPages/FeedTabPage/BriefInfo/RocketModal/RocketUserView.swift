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
        label.textAlignment = .center
        return label
    }()
    let rocketCount:UILabel = {
        let label = UILabel(frame: .zero)
        label.font = FontFamily.SFProDisplay.regular.font(size: 12)
        label.textColor = Asset.PocketColors.pocketGray.color
        label.textAlignment = .right
        return label
    }()
    let rocketImage:UIImageView = {
        let image = UIImageView(image: Asset.AppImages.rocket.image.withRenderingMode(.alwaysTemplate))
        image.tintColor = Asset.PocketColors.pocketGray.color
        return image
    }()
	let rocketBlock:UIView = {
		let c = UIView(frame: .zero)
		
		return c
	}()
    init() {
        super.init(frame:.zero)
        addSubview(avatar)
        addSubview(username)
		addSubview(rocketBlock)
		rocketBlock.addSubview(rocketCount)
        rocketBlock.addSubview(rocketImage)
		
        avatar.snp.makeConstraints { (make) in
            make.top.greaterThanOrEqualToSuperview()
			make.centerX.equalToSuperview()
			make.left.greaterThanOrEqualToSuperview()
            make.right.lessThanOrEqualToSuperview()
            make.size.equalTo(CGSize(width: 56, height: 56))
        }
        username.snp.makeConstraints { (make) in
            make.left.greaterThanOrEqualToSuperview()
            make.right.lessThanOrEqualToSuperview()
            make.centerX.equalToSuperview()
            make.top.equalTo(avatar.snp.bottom).offset(6)
        }
		rocketBlock.snp.makeConstraints { (make) in
			make.top.equalTo(username.snp.bottom).offset(6)
			make.centerX.equalToSuperview()
			make.bottom.equalToSuperview()
			make.left.greaterThanOrEqualToSuperview()
            make.right.lessThanOrEqualToSuperview()
		}
        rocketCount.snp.makeConstraints { (make) in
			make.left.top.bottom.equalToSuperview()
        }
        rocketImage.snp.makeConstraints { (make) in
            make.centerY.equalTo(rocketCount)
            make.size.equalTo(CGSize(width: 16, height: 16))
            make.left.equalTo(rocketCount.snp.right).offset(6)
            make.right.equalToSuperview()
        }
    }
    
    func setPlace(_ place:Int){
        let avatarColors = [
            Asset.PocketColors.pocketYellow.color,
			Asset.PocketColors.pocketSilver.color,
            Asset.PocketColors.pocketOrange.color
        ]
        if place >= 0 && place < avatarColors.count{
            avatar.color = avatarColors[place]
        }
        
    }
    func setPhoto(url:String){
        NetworkManager.dataTask(url: url) { (result) in
            switch result{
                case .success(let data):
                    guard let img = UIImage(data: data) else {return}
                    self.avatar.imageView.image = img
                    break;
                case .failure: break
            }
        }
    }
    func setName(first:String,last:String?=nil){
        self.username.text = first + " " + (last ?? "")
    }
    func  setRockets(count:Int) {
        self.rocketCount.text = "\(count)"
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
