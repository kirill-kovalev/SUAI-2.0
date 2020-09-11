//
//  RocketModalViewController.swift
//  rasp.guap
//
//  Created by Кирилл on 31.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit
import SUAI_API

class RocketModalViewController: ModalViewController<RocketModalView> {
    override func viewDidLoad(){
        self.rootView.titleLabel.text = ""
        DispatchQueue.global().async {
            let users = SABrief.shared.rockets.top
            DispatchQueue.main.async {
                for u in users.enumerated() {
                    let user = RocketUserView()
                    user.setPlace(u.offset)
                    user.setName(first: u.element.first_name)
                    user.setRockets(count: u.element.rockets)
                    self.content.stack.addArrangedSubview(user)
                    user.setPhoto(url: u.element.photo)
                }
            }
        }
    }
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		let today = Calendar.convertToRU(Calendar.current.component(.weekday, from: Date()))
		let diff = 7 - today
		switch diff {
			case 1:
				self.content.nextGiveaway.text = "(Следующий розыгрыш завтра)"
			case 2,3,4:
				self.content.nextGiveaway.text = "(Следующий розыгрыш через \(diff) дня)"
			default:
				self.content.nextGiveaway.text = "(Следующий розыгрыш через \(diff) дней)"
		}
	}
}
