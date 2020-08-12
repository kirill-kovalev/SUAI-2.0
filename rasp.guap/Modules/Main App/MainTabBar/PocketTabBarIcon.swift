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

    override init(frame: CGRect) {
        super.init(frame: frame)
        textColor = .clear
        highlightTextColor = Asset.PocketColors.pocketDarkBlue.color
        iconColor = Asset.PocketColors.pocketGray.color
        highlightIconColor = Asset.PocketColors.pocketDarkBlue.color
        
        
        //imageView.bounds.size = CGSize(width: 60 , height: 60)
        
        
    }
    override func updateLayout() {
        //super.updateLayout()
        titleLabel.font = FontFamily.SFProDisplay.semibold.font(size: 12)
        titleLabel.sizeToFit()
        imageView.snp.makeConstraints { (make) in
            make.width.height.equalTo(28)
            make.center.equalToSuperview()
            
        }
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom).offset(3)
//            make.bottom.lessThanOrEqualTo(safeAreaLayoutGuide.snp.bottom)
//            make.size.equalTo(CGSize.zero)
        }
        
    }
    
    override func highlightAnimation(animated: Bool, completion: (() -> ())?) {
        showAnimation(show: true)
    }
    override func deselectAnimation(animated: Bool, completion: (() -> ())?) {
        showAnimation(show: false)
    }
    
    private func showAnimation(show:Bool){
        self.imageView.tintColor = !show ? self.highlightIconColor : self.iconColor
        self.titleLabel.textColor = !show ? self.highlightTextColor : self.textColor
        self.titleLabel.layer.opacity = !show ? 1 : 0
        self.titleLabel.transform = !show ? .identity : CGAffineTransform(translationX: 0, y: 100)
        
        UIView.animate(withDuration: 0.3) {
            self.imageView.tintColor = show ? self.highlightIconColor : self.iconColor
            self.titleLabel.textColor = show ? self.highlightTextColor : self.textColor
            self.titleLabel.layer.opacity = show ? 1 : 0
            self.titleLabel.transform = show ? .identity : CGAffineTransform(translationX: 0, y: 100)
        }
    }
    
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
