//
//  ViewController.swift
//  AirrouteApp
//
//  Created by Кирилл on 30.07.2020.
//  Copyright © 2020 kirill-kovalev. All rights reserved.
//

import UIKit

class ViewController<ContentView:View>: UIViewController {

    var rootView:ContentView {
            return (self.view as! ContentView)
    }
    
    
    required init() {
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .overFullScreen
        
        //setting up keyboard display
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    
    
    
	override func loadView(){
        self.view = ContentView();
	}


    
    
    // MARK: - default required init from coder
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - keyboard function
    @objc private func keyboardWillShow(_ notification:Notification) {
        adjustingHeight(true, notification: notification)
    }
    
    @objc private func keyboardWillHide(_ notification:Notification) {
        adjustingHeight(false, notification: notification)
    }
    
    @objc private func keyboardWillChangeFrame(_ notification: Notification) {
        adjustingHeight(false, notification: notification)
    }
    private func adjustingHeight(_ show:Bool, notification:Notification) {
    
        let userInfo = (notification as NSNotification).userInfo!
        let keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let animationDurarion = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        let changeInHeight = (keyboardFrame.height ) * (show ? 1 : 0)
        
        UIView.animate(withDuration: animationDurarion, animations: { () -> Void in
            self.rootView.layoutMargins.bottom -= changeInHeight
            self.rootView.transform = .init(translationX: 0, y: -changeInHeight/2)
        })
    }

}
