//
//  NibView.swift
//  rasp.guap
//
//  Created by Кирилл on 09.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit

class NibView: View {
    class func fromNib(named: String? = nil) -> Self {
        let name = named ?? "\(Self.self)"
        guard
            let nib = Bundle.main.loadNibNamed(name, owner: nil, options: nil)
            else { fatalError("missing expected nib named: \(name)") }
        guard
            let view = nib.first as? Self
            else { fatalError("view of type \(Self.self) not found in \(nib)") }
        return view
    }

}
