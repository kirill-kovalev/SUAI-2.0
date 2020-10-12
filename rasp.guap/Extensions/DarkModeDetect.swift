//
//  DarkModeDetect.swift
//  rasp.guap
//
//  Created by Кирилл on 11.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit

extension UITraitCollection {
    static var isDarkMode: Bool {
        if #available(iOS 13.0, *) {
            return UITraitCollection.current.userInterfaceStyle == .dark
        } else {
            return false
        }
    }
}
