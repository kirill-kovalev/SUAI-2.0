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
        self.rootView.pagedView.setPage(pageNumber: self.rootView.pagedView.pageControl.numberOfPages - 1 , animated: true)
    }
    
    
    
    
    
    
    private let pages : [MainView] = [SecondPageView(),ThirdPageView(),FourthPageView(),FifthPageView()]
    
    override func viewDidLoad() {
        self.rootView.pagedView.delegate = self
        let first = FirstPageViewController()
        first.delegate = self
        self.addChild(first)
        self.rootView.pagedView.addSubview(first.view)
        first.didMove(toParent: self)
        for page in pages {
            self.rootView.pagedView.addSubview(page)
        }
        
        let last = GroupSelectPageViewController()
        self.addChild(last)
        self.rootView.pagedView.addSubview(last.view)
        
        
        
        
        self.rootView.backButton.addTarget(action: { (sender) in
                    self.navigationController?.popViewController(animated: true)
                }, for: .touchUpInside)

    }

    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        moveElipse(position: 0)
        
    }
    
    
    private func moveElipse( position:Int){
           UIView.animate(withDuration: 0.35) {
               self.rootView.elipse.setState(position: position)
           }
       }
    
    
}


