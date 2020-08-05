//
//  DegreesToRadiansConvertion.swift
//  rasp.guap
//
//  Created by Кирилл on 05.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit

extension BinaryInteger {
    var degreesToRadians: CGFloat { CGFloat(self) * .pi / 180 }
}

extension FloatingPoint {
    var degreesToRadians: Self { self * .pi / 180 }
    var radiansToDegrees: Self { self * 180 / .pi }
}
