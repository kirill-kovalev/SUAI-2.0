//
//  Button.swift
//  rasp.guap
//
//  Created by Кирилл on 31.07.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit

class Button: UIButton {

    private var actionHandler:(Button)->Void = {_ in}
    func addTarget(action: @escaping (Button)->Void, for controlEvents: UIControl.Event) {
        self.actionHandler = action
        super.addTarget(self, action: #selector(self.targetAction), for: controlEvents)
    }
    @objc private func targetAction(){
        actionHandler(self)
    }
}
