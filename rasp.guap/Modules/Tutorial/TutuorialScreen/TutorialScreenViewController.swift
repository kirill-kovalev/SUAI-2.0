//
//  TutorialScreenViewController.swift
//  rasp.guap
//
//  Created by Кирилл on 31.07.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit

class TutorialScreenViewController: ViewController<TutorialScreenView>, PagedViewDelegate {
    func pagedViewDidChanged(_ pageNumber: Int) {
       moveElipse(position: pageNumber)
    }
    
    
    let stepPages:[UIViewController] = [FirstScreenViewController()]
    
    
    
    private func moveElipse( position:Int){
        UIView.animate(withDuration: 0.35) {
            self.rootView.elipse.setState(position: position)
        }
    }
    
    override func viewDidLoad() {
        self.rootView.pagedView.delegate = self
//        for page in stepPages {
//            self.addChild(page)
//            self.rootView.pagedView.addSubview(page.view)
//        }
//        self.rootView.backButton.addTarget(action: { (sender) in
//            self.navigationController?.popViewController(animated: true)
//        }, for: .touchUpInside)
        
        
        self.rootView.pagedView.addSubview(TutorialPage<UIView>())
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
//         moveElipse(position: 0)
//        UIView.animate(withDuration: 0.35) {
//            self.navigationController?.isNavigationBarHidden = false
//        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UIView.animate(withDuration: 0.35) {
            self.navigationController?.isNavigationBarHidden = true
        }
        
    }
    
    
}


