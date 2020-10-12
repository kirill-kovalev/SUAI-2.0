//
//  Calendar.swift
//  rasp.guap
//
//  Created by Кирилл on 16.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import Foundation

extension Calendar {
    static func convertToRU(_ day: Int) -> Int {
        let d = day - 2
        return d < 0 ? 6 : d
    }
    static func convertToUS(_ day: Int) -> Int {
        let d = day + 2
        return d > 7 ? 1 : d
    }
    
    var weekdaysRu: [String] {
        var symbols = Array(self.weekdaySymbols.dropFirst())
        symbols.append(self.weekdaySymbols.first!)
        return symbols
    }
}
