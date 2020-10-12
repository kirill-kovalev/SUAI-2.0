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
    
    let authorLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = FontFamily.SFProDisplay.regular.font(size: 14)
        label.textColor = Asset.PocketColors.pocketDarkBlue.color
        label.text = "ГУАП | SUAI"
        return label
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = FontFamily.SFProDisplay.semibold.font(size: 15)
        label.textColor = Asset.PocketColors.pocketBlack.color
        label.numberOfLines = 2
        label.text = "Приходи на день абитуриента и выбирай свое будущее!"
        return label
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 87, height: 87))
        imageView.image = Asset.AppImages.photoPlaceholder.image
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let datetimeLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = FontFamily.SFProDisplay.regular.font(size: 14)
        label.textColor = Asset.PocketColors.pocketGray.color
        label.text = "4 декабря в 12:00"
        return label
    }()
    
    let likeIcon: UIImageView = {
        let icon = UIImageView(image: Asset.AppImages.Feed.likeOutline24.image )
        icon.image = icon.image?.withRenderingMode(.alwaysTemplate)
        icon.tintColor = Asset.PocketColors.pocketError.color
        return icon
    }()
    
    let likeLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = FontFamily.SFProDisplay.regular.font(size: 14)
        label.textColor = Asset.PocketColors.pocketGray.color
        label.text = "205"
        return label
    }()
    
    let commentIcon: UIImageView = {
        let icon = UIImageView(image: Asset.AppImages.Feed.commentOutline24.image )
        icon.image = icon.image?.withRenderingMode(.alwaysTemplate)
        icon.tintColor = Asset.PocketColors.pocketDarkBlue.color
        return icon
    }()
    let commentLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = FontFamily.SFProDisplay.regular.font(size: 14)
        label.textColor = Asset.PocketColors.pocketGray.color
        label.text = "205"
        return label
    }()
    
    let repostIcon: UIImageView = {
           let icon = UIImageView(image: Asset.AppImages.Feed.shareOutline24.image )
           icon.image = icon.image?.withRenderingMode(.alwaysTemplate)
           icon.tintColor = Asset.PocketColors.pocketDarkBlue.color
           return icon
   }()
   let repostLabel: UILabel = {
       let label = UILabel(frame: .zero)
       label.font = FontFamily.SFProDisplay.regular.font(size: 14)
       label.textColor = Asset.PocketColors.pocketGray.color
       label.text = "205"
       return label
   }()
    
    let viewsIcon: UIImageView = {
            let icon = UIImageView(image: Asset.AppImages.Feed.viewOutline24.image )
            icon.image = icon.image?.withRenderingMode(.alwaysTemplate)
            icon.tintColor = Asset.PocketColors.pocketDarkBlue.color
            return icon
    }()
    let viewsLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = FontFamily.SFProDisplay.regular.font(size: 14)
        label.textColor = Asset.PocketColors.pocketGray.color
        label.text = "205"
        return label
    }()
    
    required init(big: Bool = false) {
        super.init(frame: .zero)
        addViews()
        if big {
            self.imageView.layer.cornerRadius = 0
            setupConstraintsBig()
        } else {
            for view in [repostLabel, repostIcon, commentLabel, commentIcon, viewsIcon, viewsLabel] {
                view.isHidden = true
            }
            setupConstraintsSmall()
        }
        
    }
    
    private func addViews() {
        self.addSubview(imageView)
        self.addSubview(authorLabel)
        self.addSubview(titleLabel)
        
        self.addSubview(datetimeLabel)
        
        self.addSubview(likeIcon)
        self.addSubview(likeLabel)
        
        self.addSubview(commentIcon)
        self.addSubview(commentLabel)
        
        self.addSubview(repostIcon)
        self.addSubview(repostLabel)
        
        self.addSubview(viewsIcon)
        self.addSubview(viewsLabel)

    }
    
    private func setupConstraintsSmall() {
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
            make.right.equalTo(imageView.snp.left).inset(-12)
            make.bottom.lessThanOrEqualTo(likeLabel.snp.top)
        }
    }
    
    private func setupConstraintsBig() {
        self.imageView.snp.makeConstraints { (make) in
            make.height.equalTo(200)
            make.top.left.equalToSuperview().offset(-10)
            make.right.equalToSuperview().offset(10)
        }
        self.authorLabel.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(12)
            make.left.equalToSuperview()
        }
        self.datetimeLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(authorLabel)
            make.right.equalToSuperview()
        }
        self.titleLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.authorLabel.snp.bottom).offset(6)
        }
        self.likeIcon.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 16, height: 16))
            make.left.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.bottom.equalToSuperview()
        }
        self.likeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(likeIcon.snp.right).offset(7)
            make.centerY.equalTo(likeIcon)
        }
        self.commentIcon.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 16, height: 16))
            make.left.equalTo(likeLabel.snp.right).offset(7)
            make.centerY.equalTo(likeIcon)
        }
        self.commentLabel.snp.makeConstraints { (make) in
            make.left.equalTo(commentIcon.snp.right).offset(7)
            make.centerY.equalTo(likeIcon)
        }
        self.repostIcon.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 16, height: 16))
            make.left.equalTo(commentLabel.snp.right).offset(7)
            make.centerY.equalTo(likeIcon)
        }
        self.repostLabel.snp.makeConstraints { (make) in
            make.left.equalTo(repostIcon.snp.right).offset(7)
            make.centerY.equalTo(likeIcon)
        }
        self.viewsLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.centerY.equalTo(likeIcon)
        }
        self.viewsIcon.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 16, height: 16))
			make.right.equalTo(self.viewsLabel.snp.left).offset(-7)
            make.centerY.equalTo(likeIcon)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
