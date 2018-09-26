//
//  MenuViewController.swift
//  EMDR
//
//  Created by Nick Wu on 12/31/17.
//  Copyright © 2017 Nick Wu. All rights reserved.
//

import UIKit
import StoreKit

class MenuViewController: UIViewController {

    @IBOutlet weak var startButton: UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
        
        self.startButton.setImage(MyStyleKit.imageOfStartButton, for: .normal)
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedStringKey.foregroundColor: UIColor.white,
             NSAttributedStringKey.font: UIFont(name: "Nunito-Regular", size: 19)!]
    }
    
    @IBAction func startPressed(_ sender: Any) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToMenu(segue: UIStoryboardSegue) {
        
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
}
