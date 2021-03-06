//
//  PocketDivPlaceholder.swift
//  rasp.guap
//
//  Created by Кирилл on 08.09.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit
import SnapKit

class PocketDivPlaceholder:UIView{
	let loadingIndicator:PocketActivityIndicatorView = {
        let indicator = PocketActivityIndicatorView(style: .gray)
        indicator.color = Asset.PocketColors.pocketGray.color
        indicator.hidesWhenStopped = true
        return indicator
    }()
    let titleLabel:UILabel = {
        let label = UILabel(frame: .zero)
        label.font = FontFamily.SFProDisplay.bold.font(size: 20)
        label.textColor = Asset.PocketColors.pocketBlack.color
		label.textAlignment = .center
		label.numberOfLines = 0
        return label
    }()
	private let subtitleLabel:UILabel = {
        let label = UILabel(frame: .zero)
        label.font = FontFamily.SFProDisplay.semibold.font(size: 14)
        label.textColor = Asset.PocketColors.pocketGray.color
		label.textAlignment = .center
		label.numberOfLines = 0
        return label
    }()
    private let imageView:UIImageView = {
		let imageView = UIImageView(frame: .zero)
        imageView.tintColor = Asset.PocketColors.accent.color
        return imageView
    }()
	
	public var title:String? {
		get{
			self.titleLabel.text
		}
		set{
			self.titleLabel.text = newValue
		}
	}
	public var subtitle:String? {
		get{
			self.subtitleLabel.text
		}
		set{
			self.subtitleLabel.text = newValue
		}
	}
	public var image:UIImage?{
		get{
			self.imageView.image
		}
		set{
			self.imageView.image = newValue?.withRenderingMode(.alwaysTemplate)
		}
	}
	public var imageTint:UIColor {
		get{
			imageView.tintColor
		}
		set{
			imageView.tintColor = newValue
		}
		
	}
	
	required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
	init(title:String?=nil,subtitle:String?=nil,image:UIImage?=nil,tint:UIColor = Asset.PocketColors.accent.color){
		super.init(frame:.zero)
		addViews()
		setupConstraints()
		self.title = title
		self.subtitle = subtitle
		self.image = image
		self.imageTint = tint
		self.startLoading()
	}
	
	
	func startLoading(){
		self.imageView.isHidden = true
		self.titleLabel.isHidden = true
		self.subtitleLabel.isHidden = true
		self.loadingIndicator.startAnimating()
	}
	func stopLoading(){
		self.loadingIndicator.stopAnimating()
		self.titleLabel.isHidden = false
		self.subtitleLabel.isHidden = false
		self.imageView.isHidden = false
	}
	
	private var heightConstraint: Constraint? = nil
	func hide(){
		self.isHidden = true
		heightConstraint?.activate()
	}
	func show(){
		self.isHidden = false
		heightConstraint?.deactivate()
	}
	
	
	
	private func addViews(){
		self.addSubview(loadingIndicator)
		self.addSubview(titleLabel)
		self.addSubview(subtitleLabel)
		self.addSubview(imageView)
	}
	
	private func setupConstraints(){
		loadingIndicator.snp.makeConstraints { (make) in
			make.center.equalToSuperview()
			make.height.width.equalTo(45)
			make.top.equalTo(30).priority(.medium)
			make.bottom.lessThanOrEqualToSuperview().inset(30).priority(.medium)
		}
		imageView.snp.makeConstraints { (make) in
			make.width.equalTo(imageView.snp.height)
			make.height.lessThanOrEqualTo(56).priority(.medium)
			make.centerX.equalToSuperview()
			make.top.equalTo(48)
		}
		titleLabel.snp.makeConstraints { (make) in
			make.left.greaterThanOrEqualToSuperview().offset(10)
			make.right.greaterThanOrEqualToSuperview().inset(10)
			make.centerX.equalToSuperview()
			make.top.equalTo(imageView.snp.bottom).offset(12).priority(.medium)
		}
		subtitleLabel.snp.makeConstraints { (make) in
			make.left.greaterThanOrEqualToSuperview().offset(10)
			make.right.greaterThanOrEqualToSuperview().inset(10)
			make.centerX.equalToSuperview()
			make.top.equalTo(titleLabel.snp.bottom).offset(8).priority(.medium)
			make.bottom.equalToSuperview().inset(48).priority(.medium)
		}
		
		self.snp.makeConstraints { (make) in
			self.heightConstraint = make.height.equalTo(0).priority(.high).constraint
		}
	}
	
    
}
