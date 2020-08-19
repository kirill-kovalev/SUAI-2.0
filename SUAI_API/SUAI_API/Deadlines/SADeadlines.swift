//
//  SADeadlines.swift
//  SUAI_API
//
//  Created by Кирилл on 19.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import Foundation
public struct SADeadline: Codable {
    let id: Int
    let idsubject: Int?
    let subjectname: String?
    let closed: Int
    let start: Date
    let end: Date
    let comment: String
    
    var lesson: String {
        return ""
    }
}


public class SADeadlines{
    public static let shared = SADeadlines()
    public init() {
        loadFromServer()
    }
    public var nearest:[SADeadline] {
        return self.open.filter { (deadline) -> Bool in
            return deadline.end < Date().addingTimeInterval(60*60*24*7)
        }
    }
    public var open:[SADeadline]{
        return self.deadlines.filter { (d) -> Bool in
            return d.closed == 0
        }
    }
    public var closed:[SADeadline]{
        return self.deadlines.filter { (d) -> Bool in
            return d.closed == 1
        }
    }
    
    private var deadlines = [SADeadline]()
    
    public func loadFromServer(){
        PocketAPI.shared.syncDataTask(method: .getDeadlines ) { (data) in
            do {
                self.deadlines = try self.decodeDeadlines(data: data )
            }catch{
                print(error)
            }
        }
    }
    private func decodeDeadlines(data:Data) throws  -> [SADeadline] {
        let decoder = JSONDecoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        decoder.dateDecodingStrategy = .formatted(formatter)
        return try decoder.decode([SADeadline].self, from: data)
    }
}





