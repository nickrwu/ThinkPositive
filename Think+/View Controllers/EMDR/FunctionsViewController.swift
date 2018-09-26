//
//  FunctionsViewController.swift
//  EMDR
//
//  Created by Nick Wu on 12/31/17.
//  Copyright © 2017 Nick Wu. All rights reserved.
//

import UIKit
import SpriteKit
import SQLite

class FunctionsViewController: UIViewController {
    private var sessions = [Session]()
    private var selectedSession: Int?
    
    //Mark: Transitioning
   // let slideAnimator = SlideAnimator()
    
    //Mark: SpriteKit View
    @IBOutlet weak var sceneView: SKView!
    var scene: DotScene?
    
    //Mark: Outlets
    @IBOutlet var tapRecognizer: UITapGestureRecognizer!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var unpauseButton: UIButton!
    @IBOutlet weak var lbl: UILabel!
    
    //Mark: Timers
    var time = 0.0
    var timer = Timer()
    var isPlaying = false
    
    var pausePressed = false
    var screenTapped = false
    
    //App Enters Background
    @objc func willResignActive(_ notification: Notification) {
        if let scene = self.scene {
            scene.stopDot()
        }
        
        UIView.animate(withDuration: 0.2, animations: {
            self.unpauseButton.alpha = 1
            self.pauseButton.alpha = 0
            self.stopButton.alpha = 1
            self.lbl.alpha = 1
        })
        
        timer.invalidate()
        isPlaying = false
    }
    
    //Mark: Date and Time
    let currentDate = DateFormatter.localizedString(from: NSDate() as Date, dateStyle:DateFormatter.Style.medium, timeStyle: DateFormatter.Style.none)
    
    let currentTime = DateFormatter.localizedString(from: NSDate() as Date, dateStyle:DateFormatter.Style.none, timeStyle: DateFormatter.Style.short)


    override var prefersStatusBarHidden: Bool {
        return true
        //hide status bar
    }
    
    @IBAction func resetTimer(_ sender: AnyObject) {
        timer.invalidate()
        isPlaying = false
        time = 0.0
        lbl.text = String(time)
    }
    
    @objc func UpdateTimer() {
        time = time + 0.1
        lbl.text = String(format: "%.1f", time)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //App Enters Background
        NotificationCenter.default.addObserver(self, selector: #selector(willResignActive), name: UIApplication.willResignActiveNotification, object: nil)
        
        //Orientation lock
        AppUtility.lockOrientation(.landscape)
        
        self.scene = DotScene(size: CGSize(width: self.sceneView.frame.size.width, height: self.sceneView.frame.size.height))
        self.scene?.scaleMode = .aspectFill
                
        self.sceneView.presentScene(self.scene)
        
        //setting up Sprite Kit Scene
        /*let scene = DotScene(size: CGSize(width: 1536, height: 2048))
        let skView = self.view as! SKView
        scene.size = skView.bounds.size
        scene.scaleMode = .resizeFill
        skView.presentScene(scene)*/
        
        lbl.text = String(time)
        
        if(isPlaying) {
            return
        }
        
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(UpdateTimer), userInfo: nil, repeats: true)
        isPlaying = true
        
        
        /*//Gesture Recognition
        let recognizer: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: Selector(("showMenu")))
        recognizer.direction = .up
        self.view.addGestureRecognizer(recognizer)
        
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
         */
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        AppUtility.lockOrientation(.landscape, andRotateTo: .landscapeRight)
    }
    @IBAction func tapPressed(_ sender: Any) {
        if screenTapped == false{
            screenTapped = true
            
            UIView.animate(withDuration: 0.2, animations: {
                self.unpauseButton.alpha = 0
                self.pauseButton.alpha = 0
                self.stopButton.alpha = 0
                self.lbl.alpha = 0
            })
        }
          else if screenTapped == true {
                screenTapped = false
            
            if pausePressed == true{
                UIView.animate(withDuration: 0.2, animations: {
                    self.unpauseButton.alpha = 1
                    self.pauseButton.alpha = 0
                    self.stopButton.alpha = 1
                    self.lbl.alpha = 1
                })
            }
            
            else if pausePressed == false {
                UIView.animate(withDuration: 0.2, animations: {
                    self.unpauseButton.alpha = 0
                    self.pauseButton.alpha = 1
                    self.stopButton.alpha = 1
                    self.lbl.alpha = 1
                })
            }
        }
    }
    
    @IBAction func pausePressed(_ sender: Any) {
        pausePressed = true
        
        timer.invalidate()
        isPlaying = false
        
        if let scene = self.scene {
            scene.stopDot()
        }
        UIView.animate(withDuration: 0.2, animations: {
            self.pauseButton.alpha = 0
            self.unpauseButton.alpha = 1
        })
    }
    @IBAction func unpausePressed(_ sender: Any) {
        pausePressed = false
        if let scene = self.scene {
            scene.moveDot()        }
        UIView.animate(withDuration: 0.2, animations: {
            self.unpauseButton.alpha = 0
            self.pauseButton.alpha = 1
        })
        
        if(isPlaying) {
            return
        }
        
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(UpdateTimer), userInfo: nil, repeats: true)
        isPlaying = true
    }
    
    @IBAction func stopPressed(_ sender: Any) {

        timer.invalidate()
        isPlaying = false
        //showReview()
        if let scene = self.scene {
            scene.stopDot()
        }
        
        if let id = SessionsDatabase.instance.addSession1(currentDate: currentDate, currentTime: currentTime, time: time) {
            let session = Session(id: id, sessionDate: currentDate, sessionTime: currentTime, duration: time)
            sessions.append(session)
            
           // self.presentingViewController?.dismiss(animated: true){
                //self.navigationController?.popViewController(animated: false)
            //}
            
            /*let navigationController = self.presentingViewController as? UINavigationController
             
             self.presentingViewController?.presentingViewController?.dismiss(animated: true)
             {
             
             let _ = navigationController?.popViewController(animated: true)
             }
             */
        }
        
        performSegue(withIdentifier: "UnwindToMenuSegueID", sender: self)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /* MARK : Custom Slide
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination
        
        destination.transitioningDelegate = slideAnimator
        if let scene = self.scene {
            scene.stopDot()
        }
    }
    
    func swipeUp(recognizer : UISwipeGestureRecognizer)
    {
        self.performSegue(withIdentifier: "stop", sender: self)
        showReview()
    }
    */
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Don't forget to reset when view is being removed
        AppUtility.lockOrientation(.all)
        
    }
}
