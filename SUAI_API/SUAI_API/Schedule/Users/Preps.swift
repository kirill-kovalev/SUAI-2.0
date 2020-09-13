//
//  Preps.swift
//  API
//
//  Created by Кирилл on 11.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import Foundation


public class Preps :SAUsers{
    
	override var source: String { "https://api.guap.ru/rasp/custom/get-sem-preps"}
    public override init() {
        super.init()
    }
    
    required init(users: [User]) {
        super.init(users: users)
    }

}
