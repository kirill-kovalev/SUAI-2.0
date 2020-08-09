//
//  PocketDayViewController.swift
//  rasp.guap
//
//  Created by Кирилл on 09.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit

class PocketDayViewController: ViewController<PocketDayView> {

    override func loadView() {
        self.view = PocketDayView.fromNib()
    }
    override func viewDidLoad(){
        self.rootView.label.text = "TXT"
    }
}
