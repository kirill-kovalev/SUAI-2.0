//
//  PagedViewDelegate.swift
//  rasp.guap
//
//  Created by Кирилл on 05.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit

protocol PagedViewDelegate {
    func pagedViewDidChanged(_ pageNumber: Int)
}
extension PagedViewDelegate {
    func pagedViewDidChanged(_ pageNumber: Int) {
    }
}
