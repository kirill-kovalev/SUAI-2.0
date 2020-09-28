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
    

    private let days  = ["Пн","Вт","Ср","Чт","Пт","Сб","Вс"]
	
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
			self.week = (week != SATimetable.Week.outOfTable) ? week : self.week
			self.update()
		}else{
			self.rootView.daySelector.selectedIndex = getIndex(day: day)
		}
        
    }
	// MARK: - Hotfix after SwitchSelector
	func getIndex(day:Int)->Int{
		
		let shouldShowDays = self.days.enumerated().filter{
			self.delegate?.shouldShow(day: $0.offset, week: self.week) ?? false
		}.map{$0.element}
		if(day >= 0 ){
			let dayname = days[day]
			for (index,name) in shouldShowDays.enumerated() {
				if name == dayname{
					print("(getIndex) weekday:\(day) index:\(index)")
					return index
				}
			}
		}

		return shouldShowDays.count
	}
	private func getWeekDay(index:Int)->Int{
		
		let shouldShowDays = self.days.enumerated().filter{
			self.delegate?.shouldShow(day: $0.offset, week: self.week) ?? false
		}
		if index >= 0 && index < shouldShowDays.count{
			for (day,name) in self.days.enumerated() {
				if name == shouldShowDays[index].element{
					print("(getWeekDay) weekday:\(day) index:\(index)")
					return day
				}
			}
		}
		
		return -1
	}
	// MARK: - End of Hotfix after SwitchSelector

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
		
		self.rootView.daySelector.animated = false
		self.rootView.daySelector.clear()
		
		for(day,dayName) in self.days.enumerated() {
			if (delegate?.shouldShow(day: day,week:week) ?? false){
				self.rootView.daySelector.add(SwitchSelectorButton(title: dayName, titleColor: Asset.PocketColors.pocketGray.color, selectedTitleColor: Asset.PocketColors.buttonOutlineBorder.color, backgroundColor: Asset.PocketColors.pocketBlue.color,value: day))
			}
		}
		
		if (delegate?.shouldShow(day: -1,week:.outOfTable) ?? false) {
			self.rootView.daySelector.add(SwitchSelectorButton(title: "Вне Сетки" , titleColor: Asset.PocketColors.pocketGray.color, selectedTitleColor: Asset.PocketColors.buttonOutlineBorder.color, backgroundColor: Asset.PocketColors.pocketBlue.color,value: -1))
		}
		

		self.rootView.daySelector.selectedIndex = self.getIndex(day: self.day)

		
		self.rootView.daySelector.animated = true
    }
	

    
}

extension ScheduleDaySelectViewController:SwitchSelectorDelegate {
	
	func didSelect(_ index: Int) {
		
		
//		UIImpactFeedbackGenerator(style: .light).impactOccurred()
		
		if index < self.days.count {
			self.day = self.rootView.daySelector.selectedValue as? Int ?? getWeekDay(index: index)
			self.delegate?.scheduleDaySelect(didUpdate: self.day, week: self.day >= 0 ? self.week : .outOfTable)
		}else{
			self.day = -1
			self.delegate?.scheduleDaySelect(didUpdate: -1, week: .outOfTable)
		}
		
		
	}
}
