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
    var duration: Double
    
    init(id: Int64) {
        self.id = id
        sessionDate = ""
        sessionTime = ""
        duration = 0.0
    }
    
    init(id: Int64, sessionDate: String, sessionTime: String, duration: Double) {
        self.id = id
        self.sessionDate = sessionDate
        self.sessionTime = sessionTime
        self.duration = duration
    }
}
