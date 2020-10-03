//
//  SATracker.swift
//  SUAI_API
//
//  Created by Кирилл on 19.09.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import Foundation
import SwiftyVK

public class SATracker{
	public static func track(_ event:String){
		if !VK.needToSetUp {
			DispatchQueue.global(qos: .utility).async {
				let params = ["from":"iOS", "to":event]
				if PocketAPI.shared.syncSetTask(method: .track, params: params) != nil {
					print("Track: ", "\(params)")
				}else{
					print("Track Error; params: ", "\(params)")
				}
			}
		}
		
	}
}
