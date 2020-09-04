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
		
		
		
		let text = Asset.PocketColors.pocketGray.color
		let blueText = Asset.PocketColors.buttonOutlineBorder.color
		let redText = Asset.PocketColors.pocketRedButtonText.color
		
		let blue = Asset.PocketColors.pocketBlue.color
		let red = Asset.PocketColors.pocketDeadlineRed.color
		
		self.rootView.deadlineListSelector.add(SwitchSelectorButton(title: "Ближайшие", titleColor: text, selectedTitleColor: redText, backgroundColor: red))
		self.rootView.deadlineListSelector.add(SwitchSelectorButton(title: "Открытые", titleColor: text, selectedTitleColor: blueText, backgroundColor: blue))
		self.rootView.deadlineListSelector.add(SwitchSelectorButton(title: "Закрытые", titleColor: text, selectedTitleColor: blueText, backgroundColor: blue))
		

		
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.global(qos: .background).async {
                   SADeadlines.shared.loadFromServer()
        }
        self.rootView.addButton.addTarget(action: { (sender) in
            let vc = DeadlineEditableModalViewController()
            vc.onChange = {
                self.reloadItems()
            }
            self.present(vc, animated: true, completion: nil)
        }, for: .touchUpInside)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
		self.rootView.deadlineListSelector.updateView()
        DispatchQueue.global(qos: .background).async {
            SADeadlines.shared.loadFromServer()
            DispatchQueue.main.async {
                self.reloadItems()
            }
        }
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func reloadItems(){
        if SADeadlines.shared.nearest.count > 0{
            self.tabBarItem.badgeValue = "\(SADeadlines.shared.nearest.count)"
        }else {
            self.tabBarItem.badgeValue = nil
        }
        
        
		switch self.rootView.deadlineListSelector.selectedIndex {
        case 2:
            self.deadlineList.setItems(list: SADeadlines.shared.closed)
            break
        case 1:
            self.deadlineList.setItems(list: SADeadlines.shared.open)
            break
		default:
			self.deadlineList.setItems(list: SADeadlines.shared.nearest)
			break
        }
        
    }
}

extension DeadlinesTabViewController:SwitchSelectorDelegate{
	func didSelect(_ index: Int) {
		reloadItems()
	}
}

extension DeadlinesTabViewController:DeadlineListDelegate{
    func deadlineDidSelected(deadline: SADeadline) {
        let vc = DeadlineInfoModalViewController(deadline: deadline)
        vc.onChange = {
            self.reloadItems()
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    func deadlineDidChecked(deadline: SADeadline) {
        
        DispatchQueue.global(qos: .background).async {
            if deadline.closed == 0 {
                let _ = SADeadlines.shared.close(deadline: deadline)
            }else
            {
                let _ = SADeadlines.shared.reopen(deadline: deadline)
            }
            
            SADeadlines.shared.loadFromServer()
            DispatchQueue.main.async {
                self.reloadItems()
            }
        }
    }
    
    
}
