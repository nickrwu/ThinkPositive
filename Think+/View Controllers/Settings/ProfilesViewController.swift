//
//  ProfilesViewController.swift
//  Think+
//
//  Created by Nick Wu on 1/3/18.
//  Copyright © 2018 Nick Wu. All rights reserved.
//

import UIKit

class ProfilesViewController: UITableViewController {
    
    //@IBOutlet var tableView: UITableView!
    
    var arrayText:NSMutableArray!;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped(_:)))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
/*
 
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         //#warning Incomplete implementation, return the number of rows
        return arrayText.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath:  NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath)
        let dataDic = arrayText[indexPath.row] as! NSMutableDictionary
        cell.textLabel?.text = dataDic.value(forKey: "userProfile") as? String;
        return cell
        
    }
 */
   /*
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath as IndexPath)
        // if this is the currently selected indexPath, set the checkmark, otherwise remove it
        if indexPath == selectedIndexPath {
            cell.accessoryType = UITableViewCellAccessoryType.checkmark
        } else {
            cell.accessoryType = UITableViewCellAccessoryType.none
        }
        return cell
    }
    */
    @objc func addButtonTapped(_ sender: UIBarButtonItem) {
        presentAlert()
    }
    
    func presentAlert() {
        let alertController = UIAlertController(title: "Profile Name", message: "Please input your profile name:", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Confirm", style: .default)
        { (_) in
            if let field = alertController.textFields?[0] {
                // store your data
            
                UserDefaults.standard.set(field.text, forKey: "userProfile")
                UserDefaults.standard.synchronize()
                
                
            }
                
            else {
                // user did not fill field
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        alertController.addTextField
        { (textField) in
            textField.placeholder = "Profile"
        }
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    /*
    // for saving currently seletcted index path
    var selectedIndexPath: NSIndexPath? = NSIndexPath(row: 0, section: 0)  // you wouldn't normally initialize it here, this is just so this code snip works
    // likely you would set this during cellForRowAtIndexPath when you dequeue the cell that matches a saved user selection or the default
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // this gets rid of the grey row selection.  You can add the delegate didDeselectRowAtIndexPath if you want something to happen on deselection
        tableView.deselectRow(at: indexPath as IndexPath, animated: true) // animated to true makes the grey fade out, set to false for it to immediately go away
        
        // if they are selecting the same row again, there is nothing to do, just keep it checked
        if indexPath == selectedIndexPath {
            return
        }
        
        // toggle old one off and the new one on
        let newCell = tableView.cellForRow(at: indexPath as IndexPath)
        if newCell?.accessoryType == UITableViewCellAccessoryType.none {
            newCell?.accessoryType = UITableViewCellAccessoryType.checkmark
        }
        let oldCell = tableView.cellForRow(at: selectedIndexPath! as IndexPath)
        if oldCell?.accessoryType == UITableViewCellAccessoryType.checkmark {
            oldCell?.accessoryType = UITableViewCellAccessoryType.none
        }
        
        selectedIndexPath = indexPath  // save the selected index path
        
        // do whatever else you need to do upon a new selection
    }
    */
 
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
