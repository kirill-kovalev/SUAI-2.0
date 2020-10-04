//
//  FeedTabViewController.swift
//  rasp.guap
//
//  Created by Кирилл on 12.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit
import SUAI_API
import ESTabBarController_swift

class DeadlinesTabViewController: ViewController<DeadlinesTabView> {
    required init() {
        super.init()
        self.tabBarItem = ESTabBarItem(DeadineCustomTabBarIcon(), title: "Дедлайны", image: Asset.AppImages.TabBarImages.deadlines.image, selectedImage:nil, tag: 1)
		self.tabBarItem.image?.accessibilityValue = Asset.AppImages.TabBarImages.deadlines.name
        self.rootView.setTitle(self.tabBarItem.title ?? "")
    }
    

    let deadlineList = DeadlineListController()
    
    override func loadView() {
        super.loadView()

        self.addChild(deadlineList)
        self.rootView.pocketDiv.addSubview(deadlineList.view)
        deadlineList.didMove(toParent: self)
        deadlineList.view.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        deadlineList.delegate = self
		
		self.rootView.deadlineListSelector.switchDelegate = self
		
		
		setupDeadlinegroupSelector()
		
    }
	private func setupDeadlinegroupSelector(){
		let text = Asset.PocketColors.pocketGray.color
		let blueText = Asset.PocketColors.buttonOutlineBorder.color
		let redText = Asset.PocketColors.pocketRedButtonText.color
		
		let blue = Asset.PocketColors.pocketBlue.color
		let red = Asset.PocketColors.pocketDeadlineRed.color
		
		let index = self.rootView.deadlineListSelector.selectedIndex
		self.rootView.deadlineListSelector.clear()
		self.rootView.deadlineListSelector.add(SwitchSelectorButton(title: "Ближайшие", titleColor: text, selectedTitleColor: redText, backgroundColor: red,value: SADeadlineGroup.nearest))
		self.rootView.deadlineListSelector.add(SwitchSelectorButton(title: "Открытые", titleColor: text, selectedTitleColor: blueText, backgroundColor: blue,value: SADeadlineGroup.open))
		if !SADeadlines.shared.pro.isEmpty{
			self.rootView.deadlineListSelector.add(SwitchSelectorButton(title: "pro.guap", titleColor: text, selectedTitleColor: blueText, backgroundColor: blue,value: SADeadlineGroup.pro))
		}
		self.rootView.deadlineListSelector.add(SwitchSelectorButton(title: "Закрытые", titleColor: text, selectedTitleColor: blueText, backgroundColor: blue,value: SADeadlineGroup.closed))
		self.rootView.deadlineListSelector.selectedIndex = index
	}
	
	
    override func viewDidLoad() {
        super.viewDidLoad()
        
		self.rootView.placeholder.startLoading()
		self.reloadItems()
		self.setupDeadlinegroupSelector()
		
		self.rootView.addButton.addTarget(action: {_ in self.showAddModal() }, for: .touchUpInside)
		
		self.rootView.placeholderContainer.addTarget(action: { (_) in
			guard let group = (self.rootView.deadlineListSelector.selectedValue as? SADeadlineGroup) else {return}
			if group != .pro && !self.rootView.placeholder.loadingIndicator.isAnimating{
				self.showAddModal()
			}
		}, for: .touchUpInside)
		
		
		let gesture = UIPanGestureRecognizer(target: self, action: #selector(self.swipePages(_:)) )
		self.rootView.addGestureRecognizer(gesture)
    }
	
	@objc func swipePages(_ sender :UIPanGestureRecognizer){
		
		let index = self.rootView.deadlineListSelector.selectedIndex
		let translation = sender.translation(in: self.rootView)
		if sender.state == .ended,
		   abs(translation.x)/2 > abs(translation.y){
			if (translation.x > self.rootView.bounds.width/2 || sender.velocity(in: self.rootView).x > 25){
				if ( index == 0){UINotificationFeedbackGenerator().notificationOccurred(.error);return}
				self.rootView.deadlineListSelector.selectedIndex -= 1
				self.didSelect(self.rootView.deadlineListSelector.selectedIndex)

			} else if (translation.x < -self.rootView.bounds.width/2 || sender.velocity(in: self.rootView).x < -25){
				if (index == self.rootView.deadlineListSelector.count-1){UINotificationFeedbackGenerator().notificationOccurred(.error);return}
					self.rootView.deadlineListSelector.selectedIndex += 1
					self.didSelect(self.rootView.deadlineListSelector.selectedIndex)
			}
		}
		
	}
	
	
	
	private func showAddModal(){
		let vc = DeadlineEditableModalViewController()
		vc.onChange = {
			self.reloadItems()
		}
		self.present(vc, animated: true, completion: nil)
	}
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
		self.setupDeadlinegroupSelector()
		self.rootView.deadlineListSelector.updateView()
		
		
		self.rootView.placeholder.startLoading()
		if self.deadlineList.tableView.arrangedSubviews.isEmpty {
			self.rootView.placeholder.show()
		}else{
			self.rootView.placeholder.hide()
		}
        DispatchQueue.global(qos: .background).async {
			if SADeadlines.shared.loadFromServer(){
				DispatchQueue.main.async {self.rootView.placeholder.stopLoading()}
			}else{
				MainTabBarController.Snack(status: .err, text: "Не удалось загрузить дедлайны")
			}
            DispatchQueue.main.async {
				self.setupDeadlinegroupSelector()
                self.reloadItems()
            }
        }
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func reloadItems(){
		let badgeCount = SADeadlines.shared.nearest.count + SADeadlines.shared.pro.count
		if badgeCount > 0{
			self.tabBarItem.badgeValue = "\(badgeCount)"
        }else {
            self.tabBarItem.badgeValue = nil
        }
        
		var source:[SADeadline]
		guard let group = (self.rootView.deadlineListSelector.selectedValue as? SADeadlineGroup) else {return}
		switch group {
			case .closed:
			source = SADeadlines.shared.closed
			self.rootView.placeholder.subtitle = "Ты пока не выполнил ни одного дедлайна, но все впереди!"
			self.rootView.placeholder.imageTint = Asset.PocketColors.pocketDarkBlue.color
			self.rootView.placeholder.image = Asset.AppImages.DeadlineStateImages.done.image
            break
		case .open:
            source = SADeadlines.shared.open
			self.rootView.placeholder.subtitle = "Ты выполнил все дедлайны! Это достойно уважения!"
			self.rootView.placeholder.imageTint = Asset.PocketColors.pocketError.color
			self.rootView.placeholder.image = Asset.AppImages.TabBarImages.deadlines.image
            break
		case .nearest:
			source = SADeadlines.shared.nearest
			self.rootView.placeholder.subtitle = "Ты выполнил все срочные дедлайны!\n Отдохни немного и берись за\n остальные!"
			self.rootView.placeholder.imageTint = Asset.PocketColors.pocketError.color
			self.rootView.placeholder.image = Asset.AppImages.TabBarImages.deadlines.image
			break
		case .pro:
			source = SADeadlines.shared.pro
			self.rootView.placeholder.title = "Заданий пока нет!"
			self.rootView.placeholder.subtitle = "Преподаватели пока не задали тебе заданий в личном кабинете!"
			self.rootView.placeholder.imageTint = Asset.PocketColors.pocketError.color
			self.rootView.placeholder.image = Asset.AppImages.TabBarImages.deadlines.image
			break
        }
		
		if source.isEmpty {
			self.rootView.placeholder.show()
			self.deadlineList.setItems(list: [])
			self.deadlineList.view.isHidden = true
		}else{
			self.rootView.placeholder.hide()
			self.deadlineList.view.isHidden = false
			self.deadlineList.setItems(list: source)
		}
		
		//
		if  AppSettings.isTimetableNotificationsEnabled,
			NotificationManager.shared.isAuth,
			!SADeadlines.shared.setupNotifications(){
			Logger.print(from: #function, "Не получилось обновить уведомления делайнов")
		}
        
    }
}

extension DeadlinesTabViewController:SwitchSelectorDelegate{
	func didSelect(_ index: Int) {
		self.rootView.scroll.contentOffset.y = 0
		reloadItems()
	}
}

extension DeadlinesTabViewController:DeadlineListDelegate{
    func deadlineDidSelected(deadline: SADeadline) {
		self.reloadItems()
    }
    
    func deadlineDidChecked(deadline: SADeadline) {
		self.reloadItems()
    }
    
    
}
