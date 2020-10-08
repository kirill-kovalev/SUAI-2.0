//
//  PocketTabBarIcon.swift
//  rasp.guap
//
//  Created by Кирилл on 12.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import Foundation
import ESTabBarController_swift

class PocketTabBarIcon: ESTabBarItemContentView {
	
	lazy var hideText:Bool = {
		guard let window = UIApplication.shared.windows.first else {return true}
		let insets = window.safeAreaInsets
		Logger.print("HIDETEXT: \(insets.bottom)")
		return insets.bottom == 0
	}()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        highlightTextColor = Asset.PocketColors.tabbarActiveIcon.color
        iconColor = Asset.PocketColors.pocketGray.color
        highlightIconColor = Asset.PocketColors.tabbarActiveIcon.color
		textColor = AppSettings.isGoodTabBar ? .clear : iconColor
        
        //imageView.bounds.size = CGSize(width: 60 , height: 60)
        
	
		self.titleLabel.layer.opacity = AppSettings.isGoodTabBar ? 0 : 1
        imageView.snp.makeConstraints { (make) in
            make.width.height.equalTo(28)
            make.center.equalToSuperview()
        }
		if !self.hideText{
			titleLabel.snp.makeConstraints { (make) in
				make.centerX.equalToSuperview()
				make.top.equalTo(imageView.snp.bottom).offset(3)
			}
		}else{
			titleLabel.isHidden = true
			titleLabel.layer.opacity = 0
		}
        
    }
    override func updateLayout() {
        
        super.updateLayout()
        
        titleLabel.font = FontFamily.SFProDisplay.semibold.font(size: 12)
        titleLabel.sizeToFit()
    }
    

    override func deselectAnimation(animated: Bool, completion: (() -> ())?) {
		if AppSettings.isGoodTabBar{
			showAnimation(show: false)
		}else{
			self.titleLabel.textColor =  self.iconColor
		}
    }
	override func selectAnimation(animated: Bool, completion: (() -> ())?) {
		UIImpactFeedbackGenerator(style: .light).impactOccurred()
		if AppSettings.isGoodTabBar{
			showAnimation(show: true)
		}else{
			self.titleLabel.textColor = self.highlightTextColor
		}
		
	}
    
    private func showAnimation(show:Bool){
        self.imageView.tintColor = !show ? self.highlightIconColor : self.iconColor
		self.titleLabel.transform = !show ? .identity : CGAffineTransform(translationX: 0, y: 100)
		if !self.hideText{
			self.titleLabel.textColor = !show ? self.highlightTextColor : self.textColor
			self.titleLabel.layer.opacity = !show ? 1 : 0
		}else{
			self.titleLabel.layer.opacity = 0
		}
        

		UIView.animate(withDuration: 0.3) {
			self.imageView.tintColor = show ? self.highlightIconColor : self.iconColor
			if !self.hideText{
				self.titleLabel.textColor = show ? self.highlightTextColor : self.textColor
				self.titleLabel.layer.opacity = show ? 1 : 0
				self.titleLabel.transform = show ? .identity : CGAffineTransform(translationX: 0, y: 100)
			}
		}
		
        
    }
    
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
