//
//  ModalViewController.swift
//  rasp.guap
//
//  Created by Кирилл on 31.07.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit

class ModalViewController<ContentView:UIView>: ViewController<ModalView>{
    
    var content = ContentView()
    required init() {
        super.init()
        
        self.modalPresentationStyle = .overFullScreen
        self.modalTransitionStyle = .crossDissolve
        self.rootView.setContent(content)
    
        setupCloseElements()
    }
    
    private func setupCloseElements(){
        
        self.rootView.closeButton.addTarget(action: { (btn) in
            self.dismiss(animated: true, completion: nil)
        }, for: .touchUpInside)
        
        setupCloseGestures()
    }
    
    private func setupCloseGestures(){
        let swipeDown = UIPanGestureRecognizer(target: self, action: #selector(swipeDownGesture(_:)))
        self.rootView.container.addGestureRecognizer(swipeDown)
        
        let tapOutside = UITapGestureRecognizer(target: self,action: #selector(tapOutsideGesture(_:)))
        tapOutside.numberOfTouchesRequired = 1
        tapOutside.numberOfTouchesRequired = 1
        self.rootView.addGestureRecognizer(tapOutside)
    }
    
    @objc func swipeDownGesture(_ sender: UIPanGestureRecognizer){
        let translation = sender.translation(in: self.rootView)
        let velocity = sender.velocity(in: self.rootView)
        let containerSize =  self.rootView.container.bounds
        if sender.state == .changed{
            UIView.animate(withDuration: 0.01) {
                self.rootView.container.transform = .init(translationX: 0, y: translation.y * 0.6 )
            }
        } else if sender.state == .ended{
            if (translation.y > containerSize.height * 3/6) || (velocity.y > 700)   {
                self.dismiss(animated: true, completion: nil)
            }else{
                dispalyAnimation(show: true)
            }
        }
    }
    
    @objc func tapOutsideGesture(_ sender:UITapGestureRecognizer){
        let location = sender.location(in: self.rootView.container)
        if sender.state == .ended, location.y < 0 {
            self.dismiss(animated: true, completion: nil)
        }
    }

    
    
    
    
    
    

    override func viewWillAppear(_ animated: Bool) {
        if animated {
            dispalyAnimation(show: true)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if animated {
            dispalyAnimation(show: false)
        }
    }
    private func dispalyAnimation(show:Bool){
        
//        if show {
//            self.rootView.container.transform = scaleTransform.concatenating(positionTransform)
//        }
        UIView.animate(withDuration: 0.35) {
            self.rootView.container.transform = show ? . identity : ModalView.hiddenTransform
        }
    }
    
    
    
    
    
    public func setTitle(_ title:String){
        self.rootView.titleLabel.text = title
    }
    
    
    
    
    

    
    
    required init?(coder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
    }
       
}
