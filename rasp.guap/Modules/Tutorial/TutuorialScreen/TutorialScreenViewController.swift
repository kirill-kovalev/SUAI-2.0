//
//  TutorialScreenViewController.swift
//  rasp.guap
//
//  Created by Кирилл on 31.07.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit

class TutorialScreenViewController: ViewController<TutorialScreenView>, PagedViewDelegate, FirstTutorialPageSkipDelegate {
    func pagedViewDidChanged(_ pageNumber: Int) {
       moveElipse(position: pageNumber)
    }
    func skipPages() {
        print("skip")
        self.rootView.pagedView.setPage(pageNumber: self.stepPages.count - 1 , animated: true)
    }
    
    
    let stepPages:[UIViewController] = [FirstPageViewController(),FirstScreenViewController()]
    
    
    
    private func moveElipse( position:Int){
        UIView.animate(withDuration: 0.35) {
            self.rootView.elipse.setState(position: position)
        }
    }
    
    override func viewDidLoad() {
        self.rootView.pagedView.delegate = self
        (self.stepPages.first as! FirstPageViewController).delegate = self
        for page in stepPages {
            self.addChild(page)
            self.rootView.pagedView.addSubview(page.view)
            page.didMove(toParent: self)
        }
        
         self.rootView.backButton.addTarget(action: { (sender) in
                    self.navigationController?.popViewController(animated: true)
                }, for: .touchUpInside)

    }

    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UIView.animate(withDuration: 0.35) {
            self.navigationController?.isNavigationBarHidden = true
        }
        
    }
    
    
}


