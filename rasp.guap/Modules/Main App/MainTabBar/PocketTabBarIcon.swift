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
        highlightTextColor = Asset.PocketColors.pocketDarkestBlue.color
        iconColor = Asset.PocketColors.pocketGray.color
        highlightIconColor = Asset.PocketColors.pocketDarkestBlue.color
        titleLabel.isHidden = true
        
        imageView.bounds.size = CGSize(width: 60 , height: 60)
        imageView.contentScaleFactor = 2
        
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
