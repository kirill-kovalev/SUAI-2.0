//
//  ScheduleDaySelectViewController.swift
//  rasp.guap
//
//  Created by Кирилл on 15.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit

class ScheduleDaySelectViewController: ViewController<ScheduleDaySelectView> {
    var delegate: ScheduleDaySelectDelegate?
    
    private(set) var week:Timetable.Week = .odd
    private(set) var day:Int = 0
    
    override func loadView() {
        self.view = ScheduleDaySelectView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
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
        
        for i in 0..<rootView.stack.arrangedSubviews.count-1{
            let button = rootView.stack.arrangedSubviews[i] as! Button
            button.addTarget(action: { (sender) in
                self.day = i
                self.update()
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                self.delegate?.scheduleDaySelect(didUpdate: self.day, week: self.week)
            }, for: .touchUpInside)
        }
        
        let outOfTable = rootView.stack.arrangedSubviews.last as! Button
        outOfTable.addTarget(action: { (sender) in
            self.day = 6
            self.update()
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            self.delegate?.scheduleDaySelect(didUpdate: 0, week: .outOfTable)
        }, for: .touchUpInside)
        
        update()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let widthDiff =  self.rootView.stack.frame.width - self.rootView.scroll.frame.width
        
        if widthDiff > 0{
            let offset =  self.rootView.scroll.contentOffset.x
            UIView.animateKeyframes(withDuration: 0.7, delay: 0, options: [], animations: {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5) {
                    self.rootView.scroll.contentOffset.x = offset + 5
                }
                UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5) {
                    self.rootView.scroll.contentOffset.x = offset
                }
            }, completion: nil)
            
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
        
        
        
        for i in 0..<rootView.stack.arrangedSubviews.count{
            let button = rootView.stack.arrangedSubviews[i] as! Button
            button.isHidden = !(delegate?.shouldShow(day: i,week:week) ?? false)
            button.backgroundColor = i == self.day ? Asset.PocketColors.pocketBlue.color : .clear
            button.setTitleColor( i == self.day ? Asset.PocketColors.buttonOutlineBorder.color : Asset.PocketColors.pocketGray.color, for: .normal)
        }
        
        let button = rootView.stack.arrangedSubviews.last as! Button
        button.isHidden = !(delegate?.shouldShow(day: 0,week:.outOfTable) ?? false)
        
    }
    
}
