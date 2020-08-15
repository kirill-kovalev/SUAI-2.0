//
//  ScheduleDaySelectViewController.swift
//  rasp.guap
//
//  Created by Кирилл on 15.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit

class ScheduleDaySelectViewController: UIViewController {
    var delegate: ScheduleDaySelectDelegate?
    
    private var curWeek:Timetable.Week = .odd
    private var curDay:Int = 0
    
    override func loadView() {
        self.view = ScheduleDaySelectView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let containerView = (self.view as! ScheduleDaySelectView)
        
        let weekBtn = containerView.arrangedSubviews[0] as! Button
        weekBtn.addTarget(action: { (sender) in
            if self.curWeek == .odd {
                self.curWeek = .even
            } else {
                self.curWeek = .odd
            }
            self.update()
            self.delegate?.scheduleDaySelect(didUpdate: self.curDay, week: self.curWeek)
        }, for: .touchUpInside)
        
        for i in 1..<containerView.arrangedSubviews.count-1{
            let button = containerView.arrangedSubviews[i] as! Button
            button.addTarget(action: { (sender) in
                self.curDay = i-1
                self.update()
                self.delegate?.scheduleDaySelect(didUpdate: self.curDay, week: self.curWeek)
            }, for: .touchUpInside)
        }
        
        let outOfTable = containerView.arrangedSubviews.last as! Button
        outOfTable.addTarget(action: { (sender) in
            self.delegate?.scheduleDaySelect(didUpdate: 0, week: .outOfTable)
        }, for: .touchUpInside)
        
    }
    

    func update(){
        let containerView = (self.view as! ScheduleDaySelectView)
        let weekBtn = containerView.arrangedSubviews[0] as! Button
        
        if self.curWeek == .even {
            weekBtn.setTitle("Четная", for: .normal)
            weekBtn.backgroundColor = Asset.PocketColors.pocketBlue.color
            weekBtn.setTitleColor(Asset.PocketColors.buttonOutlineBorder.color, for: .normal)
        } else if self.curWeek == .odd{
            weekBtn.setTitle("Нечетная", for: .normal)
            weekBtn.backgroundColor = Asset.PocketColors.pocketDeadlineRed.color
            weekBtn.setTitleColor(Asset.PocketColors.pocketRedButtonText.color, for: .normal)
        }
        
        
        
        for i in 1..<containerView.arrangedSubviews.count-1{
            let button = containerView.arrangedSubviews[i] as! Button
            button.isHidden = !(delegate?.shouldShow(day: i-1,week:curWeek) ?? false)
            button.backgroundColor = (i-1) == self.curDay ? Asset.PocketColors.pocketBlue.color : .clear
            button.setTitleColor((i-1) == self.curDay ? Asset.PocketColors.buttonOutlineBorder.color : Asset.PocketColors.pocketGray.color, for: .normal)
        }
        
        let button = containerView.arrangedSubviews.last as! Button
        button.isHidden = !(delegate?.shouldShow(day: 0,week:.outOfTable) ?? false)
        
    }
    
}
