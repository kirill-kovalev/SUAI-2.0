//
//  ThirdPageViewController.swift
//  rasp.guap
//
//  Created by Кирилл on 06.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit

class ThirdPageViewController : ViewController<ThirdPageView> {
    
    // MARK: - View Controller lifecycle
    override func viewDidAppear(_ animated:Bool) {
        var delay = 0.0
        let duration = 4.0
        for view in self.rootView.deadlines{
            let height = view.frame.height + 20
            
            view.transform = CGAffineTransform(translationX:0, y: self.view.frame.height).concatenating(CGAffineTransform(scaleX: 0, y: 0))
            view.layer.opacity = 0
            
            UIView.animateKeyframes(withDuration: duration, delay: delay, options: [.repeat], animations: {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.15) { //Прилетела с заднего фона
                    view.transform = CGAffineTransform(translationX:0, y: height)
                    view.layer.opacity = 1
                }
                UIView.addKeyframe(withRelativeStartTime: 0.3, relativeDuration: 0.15) {//поднялось на центральное место
                    view.transform = CGAffineTransform(translationX:0, y: 0)
                }
                UIView.addKeyframe(withRelativeStartTime: 0.60, relativeDuration: 0.15) {//поднялось на место выше
                    view.transform = CGAffineTransform(translationX:0, y: -height)
                }
                UIView.addKeyframe(withRelativeStartTime: 0.89, relativeDuration: 0.10) {//улетело вверх
                    view.transform = CGAffineTransform(translationX:0, y: -3*height)
                    view.layer.opacity = 0
                }
                
            }, completion: nil)
            delay += duration * 0.2
        }
    }
    
}
