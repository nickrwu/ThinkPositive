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
    
    //Mark: Creating instance of timer class
    var stopWatchTimer = Timer()
    var time = 0

    var isPlaying = false
    var pausePressed = false
    var screenTapped = false
    
    //Mark: SpriteKit View
    @IBOutlet weak var sceneView: SKView!
    var scene: DotScene?
    
    //Mark: Outlets
    @IBOutlet var tapRecognizer: UITapGestureRecognizer!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var unpauseButton: UIButton!
    @IBOutlet weak var minLabel: UILabel!
    @IBOutlet weak var secLabel: UILabel!
    @IBOutlet weak var colonLabel: UILabel!
    
    //App Enters Background
    @objc func willResignActive(_ notification: Notification) {
        if let scene = self.scene {
            scene.stopDot()
        }
        
        UIView.animate(withDuration: 0.2, animations: {
            self.unpauseButton.alpha = 1
            self.pauseButton.alpha = 0
            self.stopButton.alpha = 1
            self.secLabel.alpha = 1
            self.minLabel.alpha = 1
            self.colonLabel.alpha = 1
        })
        
        stopWatchTimer.invalidate()
        isPlaying = false
    }
    
    //Mark: Date and Time
    let currentDate = DateFormatter.localizedString(from: NSDate() as Date, dateStyle:DateFormatter.Style.medium, timeStyle: DateFormatter.Style.none)
    
    var currentTime = DateFormatter.localizedString(from: NSDate() as Date, dateStyle:DateFormatter.Style.none, timeStyle: DateFormatter.Style.short)


    override var prefersStatusBarHidden: Bool {
        return true
        //hide status bar
    }
    
    @IBAction func resetTimer(_ sender: AnyObject) {
        stopWatchTimer.invalidate()
        isPlaying = false
        time = 0
        secLabel.text = String(time)
    }
    
    @objc func UpdateTimer() {
        time += 1
        minLabel.text = "\(time / 60)"
        secLabel.text = "\(time % 60)"
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
        
        stopWatchTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(UpdateTimer), userInfo: nil, repeats: true)
        
        if(isPlaying) {
            return
        }
        
        //timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(UpdateTimer), userInfo: nil, repeats: true)
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
                self.secLabel.alpha = 0
                self.minLabel.alpha = 0
                self.colonLabel.alpha = 0
            })
        }
          else if screenTapped == true {
                screenTapped = false
            
            if pausePressed == true{
                UIView.animate(withDuration: 0.2, animations: {
                    self.unpauseButton.alpha = 1
                    self.pauseButton.alpha = 0
                    self.stopButton.alpha = 1
                    self.secLabel.alpha = 1
                    self.minLabel.alpha = 1
                    self.colonLabel.alpha = 1
                })
            }
            
            else if pausePressed == false {
                UIView.animate(withDuration: 0.2, animations: {
                    self.unpauseButton.alpha = 0
                    self.pauseButton.alpha = 1
                    self.stopButton.alpha = 1
                    self.secLabel.alpha = 1
                    self.minLabel.alpha = 1
                    self.colonLabel.alpha = 1
                })
            }
        }
    }
    
    @IBAction func pausePressed(_ sender: Any) {
        pausePressed = true
        
        stopWatchTimer.invalidate()
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
        
        stopWatchTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(UpdateTimer), userInfo: nil, repeats: true)
        isPlaying = true
    }
    
    @IBAction func stopPressed(_ sender: Any) {

        stopWatchTimer.invalidate()
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
