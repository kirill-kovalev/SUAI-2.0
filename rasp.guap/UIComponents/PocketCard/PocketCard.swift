//
//  PocketCard.swift
//  rasp.guap
//
//  Created by Кирилл on 09.09.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit


class PocketCard: UIView {
	let image : UIImageView = {
		let image = UIImageView(frame: .zero)
		image.image = Asset.AppImages.cardBackground.image
		image.layer.masksToBounds = true
		image.layer.cornerRadius = 10
		image.contentMode = .scaleAspectFill
		return image
	}()
	
	lazy var suaiLabel:GradientLabel = {
		let label = GradientLabel(frame: .zero)
		label.font = FontFamily.TTCommons.bold.font(size: 30)
		label.text = "SUAI ID" //linear-gradient(268.33deg,#386bc1,#3a9cff)
		label.angle = 268.33
		label.gradientFrom = UIColor(red: 0.22, green: 0.42, blue: 0.76, alpha: 1.0)
		label.gradientTo = UIColor(red: 0.23, green: 0.61, blue: 1, alpha: 1.0)
		return label
	}()
	lazy var groupLabel:GradientLabel = {
		let label = GradientLabel(frame: .zero)
		label.font = FontFamily.TTCommons.bold.font(size: 30)
		label.text = "0000" //linear-gradient(268.33deg,#386bc1,#3a9cff)
		label.angle = 268.33
		label.gradientFrom = UIColor(red: 0.22, green: 0.42, blue: 0.76, alpha: 1.0)
		label.gradientTo = UIColor(red: 0.23, green: 0.61, blue: 1, alpha: 1.0)
		return label
	}()
	lazy var userLabel:UILabel = {
		let label = UILabel(frame: .zero)
		label.font = FontFamily.SFProDisplay.semibold.font(size: 18)
		label.textColor = .black
		label.text = ""
		return label
	}()
	let profileImage:UIImageView = {
		let view = UIImageView(image: Asset.AppImages.photoPlaceholder.image)
		view.layer.cornerRadius = 30
		view.layer.masksToBounds = true
		view.contentMode = .scaleAspectFill
		return view
	}()

	
	required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
	init(){
		super.init(frame: .zero)
		addViews()
		setupConstraints()
		setupView()
	}
	
	private func addViews(){
		self.addSubview(image)
		self.addSubview(suaiLabel)
		self.addSubview(groupLabel)
		self.addSubview(userLabel)
		self.addSubview(profileImage)
	}
	private func setupConstraints(){
		self.snp.makeConstraints { (make) in
			make.height.equalTo(self.snp.width).multipliedBy(0.6)
		}
		self.image.snp.makeConstraints { (make) in
			make.top.left.right.bottom.equalToSuperview()
		}
		self.suaiLabel.snp.makeConstraints { (make) in
			make.left.equalToSuperview().offset(12)
			make.bottom.equalToSuperview().inset(12)
		}
		self.groupLabel.snp.makeConstraints { (make) in
			make.right.equalToSuperview().inset(12)
			make.bottom.equalToSuperview().inset(12)
		}
		
		self.profileImage.snp.makeConstraints { (make) in
			make.size.equalTo(CGSize(width: 60, height: 60))
			make.right.equalToSuperview().inset(12)
			make.centerY.lessThanOrEqualToSuperview()
			make.bottom.lessThanOrEqualTo(suaiLabel.snp.top)
		}
		self.userLabel.snp.makeConstraints { (make) in
			make.left.equalToSuperview().offset(12)
			make.centerY.equalTo(profileImage)
		}
	}

    private func setupView(){
        
        self.backgroundColor = Asset.PocketColors.pocketWhite.color
        
        self.layer.cornerRadius = 10

		self.layer.shadowColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        self.layer.shadowRadius = 15
		self.layer.shadowOffset = CGSize(width: 10, height: 10)
		
        self.layer.shadowOpacity = 1
        self.layer.masksToBounds = false
        
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.setupView()
    }
}


