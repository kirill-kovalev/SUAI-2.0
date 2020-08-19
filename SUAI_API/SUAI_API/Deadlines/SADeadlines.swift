//
//  SADeadlines.swift
//  SUAI_API
//
//  Created by Кирилл on 19.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import Foundation
public enum SADeadlineGroup{
    case nearest
    case open
    case closed
}

public struct SADeadline: Codable {
    public let id: Int
    public let idsubject: Int?
    public let subjectname: String?
    public let closed: Int
    public let start: Date
    public let end: Date
    public let comment: String
    
    public var lesson: String {
        return ""
    }
    
    public var type: SADeadlineGroup{
        if self.closed == 1{
            return .closed
        }else{
            if self.end < Date().addingTimeInterval(60*60*24*7){
                return .nearest
            }else{
                return .open
            }
        }
    }
}


public class SADeadlines{
    public static let shared = SADeadlines()
    public init() {
        loadFromServer()
    }
    public var nearest:[SADeadline] {
        return self.open.filter { (deadline) -> Bool in
            return deadline.type == .nearest
        }
    }
    public var open:[SADeadline]{
        return self.deadlines.filter { (d) -> Bool in
            return d.type != .closed
        }
    }
    public var closed:[SADeadline]{
        return self.deadlines.filter { (d) -> Bool in
            return d.type == .closed
        }
    }
    
    private var deadlines = [SADeadline]()
    
    public func loadFromServer(){
        PocketAPI.shared.syncDataTask(method: .getDeadlines ) { (data) in
            do {
                print(data)
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





