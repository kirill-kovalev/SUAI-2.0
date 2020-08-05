//
//  FirstScreenViewController.swift
//  AirrouteApp
//
//  Created by Кирилл on 30.07.2020.
//  Copyright © 2020 kirill-kovalev. All rights reserved.
//

import UIKit

class FirstScreenViewController: ViewController<FirstScreenView>{
	
	
	
	override func viewDidLoad() {
		self.rootView.label.text = "Hello everyone!"
        rootView.btn.addTarget(action: { (sender) in
            self.present(TimetableFilterViewConroller(), animated: true, completion: nil)
        }, for: .touchUpInside)
        rootView.btn2.addTarget(action: { (sender) in
            self.navigationController?.pushViewController(StartScreenViewController(), animated: true)
        }, for: .touchUpInside)
        rootView.btn3.addTarget(action: { (btn) in
            print("hey!")
        }, for: .touchDown)
	}
	
	override func viewWillAppear(_ animated: Bool) {
		
	}
	
	override func viewDidAppear(_ animated: Bool) {
        
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		
	}
	
	override func didReceiveMemoryWarning() {
		
	}
}
