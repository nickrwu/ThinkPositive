//
//  SessionsDatabase.swift
//  Think+
//
//  Created by Nick Wu on 3/22/18.
//  Copyright © 2018 Nick Wu. All rights reserved.
//

import SQLite

class SessionsDatabase {
    
    private let sessions = Table("sessions").order(Expression<Int64>("id").desc)
    
    private let id = Expression<Int64>("id")
    private let sessionDate = Expression<String>("sessionDate")
    private let sessionTime = Expression<String>("sessionTime")
    private let duration = Expression<Double>("duration")


    static let instance = SessionsDatabase()
    var sessionsDatabase: Connection!
    
    private init() {
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
            ).first!
        
        do {
            
            sessionsDatabase = try Connection("\(path)/Stephencelis.sqlite3")
            createTable()
        } catch {
            sessionsDatabase = nil
            print ("Unable to open database")
        }
    }
    
    func createTable() {
        
        do {
            try sessionsDatabase!.run(sessions.create(ifNotExists: true) { table in
                table.column(self.id, primaryKey: true)
                table.column(self.sessionDate)
                table.column(self.sessionTime)
                table.column(self.duration)
            })

        } catch {
            print("Unable to create table")
        }
    }
    
    func addSession1(currentDate: String, currentTime: String, time: Double) -> Int64? {
        do {
            let insert = sessions.insert(self.sessionDate <- currentDate, self.sessionTime <- currentTime, self.duration <- time)
            let id = try sessionsDatabase!.run(insert)
            
            return id
        } catch {
            print("Insert failed")
            return nil
        }
    }
    
    
    func getSession() -> [Session] {
        var sessions = [Session]()
        do {
            for session in try sessionsDatabase!.prepare(self.sessions) {
                sessions.append(Session(
                    id: Int64(session[id]),
                    sessionDate: session[sessionDate],
                    sessionTime: session[sessionTime],
                    duration: session[duration]))
            }
        } catch {
            print("Select failed")
        }
        
        return sessions
    }
    
    func deleteSession(cid: Int64) -> Bool {
        do {
            let session = sessions.filter(id == cid).order(id.desc).limit(1)
            try sessionsDatabase!.run(session.delete())
            return true
        } catch {
            print("Delete failed")
        }
        return false
    }
    
    func updateSession(cid:Int64, newSession: Session) -> Bool {
        let session = sessions
            .order(id.desc)
            .filter(id == cid)
        do {
            let update = session.update([
                sessionDate <- newSession.sessionDate,
                sessionTime <- newSession.sessionTime,
                duration <- newSession.duration
                ])
            if try sessionsDatabase!.run(update) > 0 {
                return true
            }
        } catch {
            print("Update failed: \(error)")
        }
        
        return false
    }
}
