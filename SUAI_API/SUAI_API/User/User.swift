//
//  User.swift
//  SUAI_API
//
//  Created by Кирилл on 19.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import Foundation

public class SAUser{
    public struct Settings: Codable {
        let group: String
        let idtab: Int
        let animations: Int
        let building: Int
        let banners: Int
        let prologin: String
        let propass: String
    }
    public init() {
        
    }
    func loadFromServer(){
        
    }
    
}
