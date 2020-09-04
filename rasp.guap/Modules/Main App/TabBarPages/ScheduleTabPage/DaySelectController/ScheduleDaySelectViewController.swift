//
//  ScheduleDaySelectViewController.swift
//  rasp.guap
//
//  Created by Кирилл on 15.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit
import SUAI_API

class ScheduleDaySelectViewController: ViewController<ScheduleDaySelectView> {
    var delegate: ScheduleDaySelectDelegate?
    
    private(set) var week:SATimetable.Week = .outOfTable
    private(set) var day:Int = 0
    

    private let days  = ["Пн","Вт","Ср","Чт","Пт","Сб"]
	
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.rootView.daySelector.switchDelegate = self
        self.rootView.weekBtn.addTarget(action: { (sender) in
            if self.week == .odd {
                self.week = .even
            } else {
                self.week = .odd
            }
			
            self.update()
			
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            self.delegate?.scheduleDaySelect(didUpdate: self.day, week: self.week)
			
        }, for: .touchUpInside)
        
    }
    

    func set(day:Int,week:SATimetable.Week){
        self.day = day
		if self.week != week {
			self.week = (week != SATimetable.Week.outOfTable) ? week : .even
			
			self.update()
			
		}else{
			self.rootView.daySelector.selectedIndex = day
		}
        
    }

    func update(){
        
        if self.week == .even {
            self.rootView.weekBtn.setTitle("Четная", for: .normal)
            self.rootView.weekBtn.backgroundColor = Asset.PocketColors.pocketBlue.color
            self.rootView.weekBtn.setTitleColor(Asset.PocketColors.buttonOutlineBorder.color, for: .normal)
        } else if self.week == .odd{
            self.rootView.weekBtn.setTitle("Нечетная", for: .normal)
            self.rootView.weekBtn.backgroundColor = Asset.PocketColors.pocketDeadlineRed.color
            self.rootView.weekBtn.setTitleColor(Asset.PocketColors.pocketRedButtonText.color, for: .normal)
        }
		
		self.rootView.daySelector.clear()
		
		for(i,day) in self.days.enumerated() {
			if (delegate?.shouldShow(day: i,week:week) ?? false){
				self.rootView.daySelector.add(SwitchSelectorButton(title: day, titleColor: Asset.PocketColors.pocketGray.color, selectedTitleColor: Asset.PocketColors.buttonOutlineBorder.color, backgroundColor: Asset.PocketColors.pocketBlue.color))
			}
		}
		if (delegate?.shouldShow(day: -1,week:.outOfTable) ?? false) {
			self.rootView.daySelector.add(SwitchSelectorButton(title: "Вне Сетки" , titleColor: Asset.PocketColors.pocketGray.color, selectedTitleColor: Asset.PocketColors.buttonOutlineBorder.color, backgroundColor: Asset.PocketColors.pocketBlue.color))
		}
		self.rootView.daySelector.animated = false
		self.rootView.daySelector.selectedIndex =  self.day > 0 ? self.day : self.days.count-1
		self.rootView.daySelector.animated = true
    }
	

    
}

extension ScheduleDaySelectViewController:SwitchSelectorDelegate {
	func didSelect(_ index: Int) {
		
		UIImpactFeedbackGenerator(style: .light).impactOccurred()
		
		if index < self.days.count {
			self.day = index
			self.delegate?.scheduleDaySelect(didUpdate: self.day, week: self.week)
		}else{
			self.day = -1
			self.delegate?.scheduleDaySelect(didUpdate: 0, week: .outOfTable)
		}
		
		
	}
}
