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
	
	private func wordCase(_ n:Int) -> String{
		let words = ["день","дня","дней"]
		guard words.count >= 3 else { return ""}
		var n = n
		if (n >= 5 && n <= 20) {
		  return words[2];
		}
		n = n % 10;
		if (n == 1) {
		  return  words[0];
		}
		if (n >= 2 && n <= 4) {
		  return  words[1];
		}
		return  words[2];
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		var todayComponents = Calendar.current.dateComponents([.year,.month], from: Date())
		todayComponents.month = (todayComponents.month ?? 0) + 1
		if let nextPlay = Calendar.current.date(from: todayComponents){
			var diff:Int = Int(nextPlay.timeIntervalSince(Date()) / (3600*24))
			if diff < 2{
				self.content.nextGiveaway.text = "(Следующий розыгрыш завтра)"
			}else {
			    self.content.nextGiveaway.text = "(Следующий розыгрыш через \(diff) \(wordCase(diff))"
			}
			
		}
		
//		let
//		let diff = 7 - today
//		switch diff {
//			case 1:
//				self.content.nextGiveaway.text = "(Следующий розыгрыш завтра)"
//			case 2,3,4:
//				self.content.nextGiveaway.text = "(Следующий розыгрыш через \(diff) дня)"
//			default:
//				self.content.nextGiveaway.text = "(Следующий розыгрыш через \(diff) дней)"
//		}
	}
}
