//
//  TabBarIcon.swift
//  rasp.guap
//
//  Created by Кирилл on 12.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import Foundation
import ESTabBarController_swift

class DeadineCustomTabBarIcon: PocketTabBarIcon {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        highlightTextColor = Asset.PocketColors.pocketError.color
        highlightIconColor = Asset.PocketColors.pocketError.color
        self.badgeView = DeadineCustomTabBarItemBadgeView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
class DeadineCustomTabBarItemBadgeView: ESTabBarItemBadgeView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.badgeValue = "3"
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
