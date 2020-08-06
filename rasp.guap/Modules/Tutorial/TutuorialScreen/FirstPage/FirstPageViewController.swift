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
    required init() {
        super.init()
    }
    
    init(delegate: FirstTutorialPageSkipDelegate) {
        super.init()
        self.delegate = delegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        self.rootView.tapGesture.addTarget(self, action: #selector(action(_:)))
    }
    
    @objc private func action(_ sender:UITapGestureRecognizer){
        print("tap")
        self.delegate?.skipPages()
    }
}
