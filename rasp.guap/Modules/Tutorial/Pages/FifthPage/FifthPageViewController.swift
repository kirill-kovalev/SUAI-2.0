//
//  FifthPageViewController.swift
//  rasp.guap
//
//  Created by Кирилл on 06.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit

class FifthPageViewController : ViewController<FifthPageView> {
    
    // MARK: - View Controller lifecycle
    override func viewDidAppear(_ animated:Bool) {
        setupAnimations()
        NotificationCenter.default.addObserver(self, selector: #selector(self.setupAnimations), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    @objc private func setupAnimations(){
        let size = CGSize(width: self.rootView.containers[0].frame.size.width * 1.15 ,
                          height: self.rootView.containers[0].frame.size.height * 1.15)
        
        self.rootView.containers[0].transform = CGAffineTransform(translationX: -size.width/2, y: -size.height/2)
        self.rootView.containers[1].transform = CGAffineTransform(translationX:  size.width/2, y: -size.height/2)
        self.rootView.containers[2].transform = CGAffineTransform(translationX: -size.width/2, y:  size.height/2)
        self.rootView.containers[3].transform = CGAffineTransform(translationX:  size.width/2, y:  size.height/2)
        
        UIView.animateKeyframes(withDuration: 4, delay: 0, options: [.repeat], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.11) {
                self.rootView.containers[3].transform = CGAffineTransform(translationX: -size.width/2, y: -size.height/2)
                self.rootView.containers[0].transform = CGAffineTransform(translationX:  size.width/2, y: -size.height/2)
                self.rootView.containers[1].transform = CGAffineTransform(translationX: -size.width/2, y:  size.height/2)
                self.rootView.containers[2].transform = CGAffineTransform(translationX:  size.width/2, y:  size.height/2)
            }
            UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.11) {
                self.rootView.containers[2].transform = CGAffineTransform(translationX: -size.width/2, y: -size.height/2)
                self.rootView.containers[3].transform = CGAffineTransform(translationX:  size.width/2, y: -size.height/2)
                self.rootView.containers[0].transform = CGAffineTransform(translationX: -size.width/2, y:  size.height/2)
                self.rootView.containers[1].transform = CGAffineTransform(translationX:  size.width/2, y:  size.height/2)
            }
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.11) {
                self.rootView.containers[1].transform = CGAffineTransform(translationX: -size.width/2, y: -size.height/2)
                self.rootView.containers[2].transform = CGAffineTransform(translationX:  size.width/2, y: -size.height/2)
                self.rootView.containers[3].transform = CGAffineTransform(translationX: -size.width/2, y:  size.height/2)
                self.rootView.containers[0].transform = CGAffineTransform(translationX:  size.width/2, y:  size.height/2)
            }
            UIView.addKeyframe(withRelativeStartTime: 0.75, relativeDuration: 0.11) {
                self.rootView.containers[0].transform = CGAffineTransform(translationX: -size.width/2, y: -size.height/2)
                self.rootView.containers[1].transform = CGAffineTransform(translationX:  size.width/2, y: -size.height/2)
                self.rootView.containers[2].transform = CGAffineTransform(translationX: -size.width/2, y:  size.height/2)
                self.rootView.containers[3].transform = CGAffineTransform(translationX:  size.width/2, y:  size.height/2)
                
            }
            
            UIView.addKeyframe(withRelativeStartTime: 0.99, relativeDuration: 0.01) {
                self.rootView.containers[0].transform = CGAffineTransform(translationX: -size.width/2, y: -size.height/2)
                self.rootView.containers[1].transform = CGAffineTransform(translationX:  size.width/2, y: -size.height/2)
                self.rootView.containers[2].transform = CGAffineTransform(translationX: -size.width/2, y:  size.height/2)
                self.rootView.containers[3].transform = CGAffineTransform(translationX:  size.width/2, y:  size.height/2)
            }
            
        }, completion: nil)
    }
    
}
