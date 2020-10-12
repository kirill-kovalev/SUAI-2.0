//
//  ASCollectionView.swift
//  rasp.guap
//
//  Created by Кирилл on 26.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit

class ASCollectionView: UICollectionView {
    override var contentSize: CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}
