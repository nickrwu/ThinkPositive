//
//  LogViewController.swift
//  EMDR
//
//  Created by Nick Wu on 12/31/17.
//  Copyright © 2017 Nick Wu. All rights reserved.
//

import UIKit
import SQLite

class LogViewController: UITableViewController{
    //Mark: Sqlite
    /*
    var sessionsDatabase: Connection!
    
    let sessionsTable = Table("sessions")
    let id = Expression<Int>("id")
    let sessionDate = Expression<String>("sessionDate")
    let sessionTime = Expression<String>("sessionTime")
    let duration = Expression<Double>("duration")
    let note = Expression<String>("note")
    */
    private var sessions = [Session]()
    private var selectedSession: Int?
    
    //Mark: Outlets
    
    @IBOutlet weak var sessionsTableView: UITableView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor.white,
             NSAttributedString.Key.font: UIFont(name: "Nunito-Regular", size: 19)!]
        
        self.navigationItem.rightBarButtonItem = editButtonItem
        
        sessionsTableView.dataSource = self
        sessionsTableView.delegate = self
        
        sessions = SessionsDatabase.instance.getSession()
        sessionsTableView.reloadData()
    }
    
    
    // MARK: TableView Functions
   
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sessions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SessionCell")!
        var label: UILabel?
        
        label = cell.viewWithTag(11) as? UILabel // ID label
        label?.text = "Session \(String(describing: sessions[indexPath.row].id!))"
        
        label = cell.viewWithTag(12) as? UILabel // Date label
        label?.text = "Date: \(sessions[indexPath.row].sessionDate)"
        
        label = cell.viewWithTag(13) as? UILabel // Time label
        label?.text = "Time: \(sessions[indexPath.row].sessionTime)"

        label = cell.viewWithTag(14) as? UILabel // Duration label
        label?.text = "Duration: \(String(format: "%1u", sessions[indexPath.row].duration / 60)) Minutes \(String(format: "%1u", sessions[indexPath.row].duration % 60)) Seconds"
        
        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            _ = SessionsDatabase.instance.deleteSession(cid: sessions[indexPath.row].id!)
            sessions.remove(at: indexPath.row)
            sessionsTableView.deleteRows(at: [IndexPath(row: indexPath.row, section: 0) as IndexPath], with: .fade)
            //tableView.deleteRows(at: [indexPath], with: .fade)
            
            
            //sessionsTableView.reloadData()
            sessions = SessionsDatabase.instance.getSession()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        sessions = SessionsDatabase.instance.getSession()
        sessionsTableView.reloadData()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        sessionsTableView.reloadData()
        sessions = SessionsDatabase.instance.getSession()

        
        //AppUtility.lockOrientation(.portrait)
        // Or to rotate and lock
        AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        
        
        // Don't forget to reset when view is being removed
        AppUtility.lockOrientation(.all)
    }
}


