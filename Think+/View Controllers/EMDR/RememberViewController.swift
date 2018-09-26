//
//  RememberViewController.swift
//  Think+
//
//  Created by Nick Wu on 1/3/18.
//  Copyright © 2018 Nick Wu. All rights reserved.
//

import UIKit

class RememberViewController: UIViewController {

    @IBOutlet weak var dontShow: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
    }

    @IBAction func dontShowAgain(_ sender: Any) {
        let userDefaults = UserDefaults.standard
        
        userDefaults.set(true, forKey: "shownComplete")
        
        userDefaults.synchronize()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Don't forget to reset when view is being removed
        AppUtility.lockOrientation(.all)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
