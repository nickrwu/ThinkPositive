//
//  SessionDatabase.swift
//  
//
//  Created by Nick Wu on 3/21/18.
//
         
import Foundation
import SQLite

class Session {
    
    let id: Int64?
    var sessionDate: String
    var sessionTime: String
    var duration: Int
    
    init(id: Int64) {
        self.id = id
        sessionDate = ""
        sessionTime = ""
        duration = 0
    }
    
    init(id: Int64, sessionDate: String, sessionTime: String, duration: Int) {
        self.id = id
        self.sessionDate = sessionDate
        self.sessionTime = sessionTime
        self.duration = duration
    }
}
