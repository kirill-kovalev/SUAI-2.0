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
    public let subject_name: String?
    public let deadline_name: String?
    public let closed: Int
    public let start: Date
    public let end: Date
    public let comment: String
    
    public var lesson: String {
        return ""
    }
    public init(id: Int = 0,
                subject_name: String = "",
                deadline_name: String? = "",
                closed: Int = 0,
                start: Date = Date(),
                end: Date = Date(),
                comment: String = ""
    ){
        self.id = id
        self.subject_name = subject_name
        self.deadline_name = deadline_name
        self.closed = closed
        self.start = start
        self.end = end
        self.comment = comment
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
        PocketAPI.shared.syncLoadTask(method: .getDeadlines ) { (data) in
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
    
    
    
    public func close(deadline: SADeadline) -> Bool {
        var success = false
        PocketAPI.shared.syncSetTask(method: .closeDeadline, params: ["id":deadline.id]) { (data) in
            success = String(data: data, encoding: .utf8)?.contains("success") ?? false
        }
        self.loadFromServer()
        return success
    }
    
    public func reopen(deadline: SADeadline) -> Bool {
        var success = false
        PocketAPI.shared.syncSetTask(method: .openDeadline, params: ["id":deadline.id]) { (data) in
             success = String(data: data, encoding: .utf8)?.contains("success") ?? false
        }
        self.loadFromServer()
        return success
    }
    
    public func create(deadline: SADeadline) -> Bool {
        
        return  false
    }
    public func edit(deadline: SADeadline) -> Bool{
        var success = false
        PocketAPI.shared.syncSetTask(method: .editDeadline, params: ["id":deadline.id]) { (data) in
             success = String(data: data, encoding: .utf8)?.contains("success") ?? false
        }
        self.loadFromServer()
        return success
    }
    public func delete(deadline: SADeadline) -> Bool{
        var success = false
        PocketAPI.shared.syncSetTask(method: .deleteDeadline, params: ["id":deadline.id]) { (data) in
             success = String(data: data, encoding: .utf8)?.contains("success") ?? false
        }
        self.loadFromServer()
        return success
    }
    
    
    
}





