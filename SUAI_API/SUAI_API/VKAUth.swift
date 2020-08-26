//
//  VKAUth.swift
//  SUAI_API
//
//  Created by Кирилл on 24.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import Foundation
import SwiftyVK
public class VKDelegate:SwiftyVKDelegate{
    public init() {
        
    }
    public func vkNeedsScopes(for sessionId: String) -> Scopes {
        return [.offline]
    }
    
    public func vkNeedToPresent(viewController: VKViewController) {
        
    }
    
    
}
