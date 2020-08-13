//
//  SecondPageViewController.swift
//  rasp.guap
//
//  Created by Кирилл on 06.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit

class SecondPageViewController : ViewController<SecondPageView> {
    
    // MARK: - View Controller lifecycle
    override func viewDidLoad() {
        
//        UIView.animateKeyframes(withDuration: 3, delay: 0, options: [.repeat], animations: {
//            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.25) {
//                self.rootView.divFirst?.transform = .init(scaleX: 0.9, y: 0.9)
//                self.rootView.divSecond?.transform = .init(scaleX: 1, y: 1)
//            }
//            UIView.addKeyframe(withRelativeStartTime:0.25, relativeDuration: 0.5) {
//                self.rootView.divFirst?.transform = .init(scaleX: 1, y: 1)
//                self.rootView.divSecond?.transform = .init(scaleX: 0.9, y: 0.9)
//            }
//            UIView.addKeyframe(withRelativeStartTime:0.75, relativeDuration: 0.25) {
//                self.rootView.divFirst?.transform = .init(scaleX: 0.9, y: 0.9)
//                self.rootView.divSecond?.transform = .init(scaleX: 1, y: 1)
//            }
//        }, completion: nil)
        
        
        
        
        
    }
    override func viewDidLayoutSubviews() {
        setupAnimations()
        NotificationCenter.default.addObserver(self, selector: #selector(self.setupAnimations), name: UIApplication.didBecomeActiveNotification, object: nil)
       
    }
    
    @objc private func setupAnimations(){
        self.rootView.divFirst.transform = .identity
        self.rootView.divSecond.transform = .init(scaleX: 0.95, y: 0.95)
        UIView.animate(withDuration: 2, delay: 0, options: [.curveLinear,.repeat,.autoreverse], animations: {
            self.rootView.divFirst.transform = .init(scaleX: 0.95, y: 0.95)
            self.rootView.divSecond.transform = .identity
        }, completion: nil)
    }
    
    
}
