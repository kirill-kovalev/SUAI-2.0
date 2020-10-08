//
//  FeedOrderSettingsViewController.swift
//  rasp.guap
//
//  Created by Кирилл on 04.10.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit
import SUAI_API

class FeedOrderSettingsViewController: ModalViewController<FeedOrderSettingsView> {
	
	var sources:[FeedSource] = [] {
		didSet{
			DispatchQueue.main.async {
				self.updateList()
			}
		}
	}
	var selection:[Int:Bool] = [:]
	static let news = SANews()
	var news:SANews {Self.news}
	override func viewDidLoad() {
		super.viewDidLoad()
		self.setTitle("Фильтр новостей")
		if self.news.sources.isEmpty{
			self.sources = SANews.shared.sources
		}else{
			self.sources = self.news.sources
		}
		
		
		self.content.activityIndicator.startAnimating()
		DispatchQueue.global().async {
			
			if self.news.loadSourceList(default: true){
				self.sources = self.news.sources
			}else{
				self.sources = SANews.shared.sources
			}
			DispatchQueue.main.async { self.content.activityIndicator.removeFromSuperview() }
		}
		self.content.submitButton.addTarget(action: { (_) in
			self.content.submitButton.disable()
			
			self.sendToServer()
			
		}, for: .touchUpInside)
		
	}
	
	func sendToServer(){
		DispatchQueue.global().async {
			let newSources = self.sources.enumerated().filter { (iterator) -> Bool in
				self.selection[iterator.offset] ?? true
			}.compactMap { $0.element }
			if SANews.updateSorceList(sources: newSources) {
				Logger.print(from: #function, "update success")
				MainTabBarController.Snack(status: .ok, text: "Список источников обновлен")
				UINotificationFeedbackGenerator().notificationOccurred(.success)
			}else{
				MainTabBarController.Snack(status: .err, text: "Ошибка обновления списка источников")
				Logger.print(from: #function, "update err")
				UINotificationFeedbackGenerator().notificationOccurred(.error)
			}
			
			let news = SANews()
			if news.loadSourceList(default: true){
				self.sources = news.sources
			}

			DispatchQueue.main.async {
				self.content.submitButton.enable()
			}
		}
	}


	func updateList(){
		self.content.stack.arrangedSubviews.forEach { $0.removeFromSuperview() }
		for (index,source) in self.sources.enumerated() {
			let block = AppSettingsBlock(title: source.name)
			block.toggle.isOn = (SANews.shared.get(name: source.name) != nil)
			block.toggle.tag = index
			self.selection[index] = block.toggle.isOn
			block.toggle.addTarget(self, action: #selector(self.toggle(_:)), for: .valueChanged)
			self.content.stack.addArrangedSubview(block)
		}
	}
	@objc func toggle(_ sender:UISwitch){
		self.selection[sender.tag] = sender.isOn
		var flag = false
		for (_,val) in self.selection { flag = val || flag }
		self.content.submitButton.isActive = flag
	}
}
