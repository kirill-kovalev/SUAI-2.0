//
//  FourthPageViewController.swift
//  rasp.guap
//
//  Created by Кирилл on 06.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit

class FourthPageViewController : ViewController<FourthPageView> {
    
    // MARK: - View Controller lifecycle
    override func loadView() {
        super.loadView()
    }
    override func viewDidLoad() {
        let timetable = TimetableViewController()
        let someview = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        someview.backgroundColor = .red
        
        self.addChild(timetable)
        self.rootView.tableContainer.addSubview(timetable.view)
        print( self.rootView.tableContainer.content)
        timetable.tableView.snp.makeConstraints { (make) in
            make.top.bottom.left.right.equalToSuperview()
            make.height.greaterThanOrEqualTo(270)
        }
        timetable.didMove(toParent: self)
    }
    
}

