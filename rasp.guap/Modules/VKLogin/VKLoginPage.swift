//
//  VKLoginPage.swift
//  rasp.guap
//
//  Created by Кирилл on 19.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit
import SUAI_API
import SwiftyVK

class VKLoginPageViewController: UIViewController {
    
    @IBOutlet weak var errLabel: UILabel!
    @IBAction func loginViaVK(_ sender: UIButton, forEvent event: UIEvent) {
        VK.sessions.default.logIn(onSuccess: { _ in
            PocketAPI.shared.setToken(VK.sessions.default.accessToken!.get()!)
            DispatchQueue.main.async {
                UIApplication.shared.appDelegate.application(UIApplication.shared, didFinishLaunchingWithOptions: nil)
            }
        }) { (err) in
            DispatchQueue.main.async {
                self.errLabel.text = err.localizedDescription
                self.errLabel.isHidden = false
            }
            
            print(err)
        }
    }
    override func viewDidAppear(_ animated: Bool){
        VK.setUp(appId: "7578765", delegate: self)
        
    }
}
extension VKLoginPageViewController:SwiftyVKDelegate{
    func vkNeedToPresent(viewController: VKViewController) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    func vkNeedsScopes(for sessionId: String) -> Scopes { [.offline,.stats] }
    
    
}
