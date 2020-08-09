//
//  TutorialScreenViewController.swift
//  rasp.guap
//
//  Created by Кирилл on 31.07.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit

class TutorialScreenViewController: ViewController<TutorialScreenView> {
    
    private let pages : [UIViewController] = [FirstPageViewController(),SecondPageViewController(),ThirdPageViewController(),FourthPageViewController(),FifthPageViewController(),GroupSelectPageViewController()]
    
    // MARK: - ViewController lifecycle
    
    override func viewDidLoad() {
        self.rootView.pagedView.delegate = self
        
        (pages[0] as! FirstPageViewController).delegate = self
        
        for page in pages {
            self.addChild(page)
            self.rootView.pagedView.addSubview(page.view)
            page.didMove(toParent: self)
        }
        
        self.rootView.backButton.addTarget(action: { (sender) in
            self.navigationController?.popViewController(animated: true)
        }, for: .touchUpInside)
        
    }
    

    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        moveElipse(position: 0)
    }
    
    // MARK: - support functions
    private func moveElipse( position:Int){
        UIView.animate(withDuration: 0.35) {
            self.rootView.elipse.setState(position: position)
        }
    }
    
}


extension TutorialScreenViewController:PagedViewDelegate {
    func pagedViewDidChanged(_ pageNumber: Int) {
        moveElipse(position: pageNumber)
    }
}

extension TutorialScreenViewController:FirstTutorialPageSkipDelegate {
    func skipPages() {
        self.rootView.pagedView.setPage(pageNumber: self.rootView.pagedView.pageControl.numberOfPages - 1 , animated: true)
    }
}
