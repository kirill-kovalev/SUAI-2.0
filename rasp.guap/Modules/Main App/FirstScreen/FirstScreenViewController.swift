//
//  FirstScreenViewController.swift
//  AirrouteApp
//
//  Created by Кирилл on 30.07.2020.
//  Copyright © 2020 kirill-kovalev. All rights reserved.
//

import UIKit

class FirstScreenViewController: ViewController<FirstScreenView>{
	
	
	// MARK: - ViewController lifecycle
	override func viewDidLoad() {
        super.viewDidLoad()
		self.rootView.label.text = ""
        rootView.btn.addTarget(action: { (sender) in
            self.present(TimetableFilterViewConroller(), animated: true, completion: nil)
        }, for: .touchUpInside)
        rootView.btn2.addTarget(action: { (sender) in
            self.navigationController?.pushViewController(TutorialScreenViewController(), animated: true)
        }, for: .touchUpInside)
        
	}
}
