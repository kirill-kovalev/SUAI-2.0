//
//  FirstPageViewController.swift
//  rasp.guap
//
//  Created by Кирилл on 06.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit

class FirstPageViewController : ViewController<FirstPageView> {
    
    var delegate:FirstTutorialPageSkipDelegate?
    
    // MARK: - View Controller lifecycle
    override func viewDidLoad() {
        self.rootView.tapGesture.addTarget(self, action: #selector(action(_:)))
    }
    
    
    // MARK: - Actions
    @objc private func action(_ sender:UITapGestureRecognizer){
        self.delegate?.skipPages()
    }
}
