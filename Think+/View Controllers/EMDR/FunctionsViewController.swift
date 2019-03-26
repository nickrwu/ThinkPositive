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
import AVFoundation
import SwiftySound

class FunctionsViewController: UIViewController {
    
    
    /*override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }*/
    
    override var preferredScreenEdgesDeferringSystemGestures: UIRectEdge {
        return .bottom
    }
    
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
   // @IBOutlet weak var sceneView: SKView!
    //var scene: DotScene?
    
    //Mark: Creating instance of speed class
    var speed = 5
    
    
    //Mark: Outlets
    @IBOutlet weak var dotImage: UIImageView!
    @IBOutlet var dotYConstraint: NSLayoutConstraint!
    @IBOutlet weak var dotXConstraint: NSLayoutConstraint!
    @IBOutlet weak var soundPicker: UISegmentedControl!
    @IBOutlet weak var spdStepper: UIStepper!
    @IBOutlet weak var spdLabel: UILabel!
    @IBOutlet var tapRecognizer: UITapGestureRecognizer!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var unpauseButton: UIButton!
    @IBOutlet weak var minLabel: UILabel!
    @IBOutlet weak var secLabel: UILabel!
    @IBOutlet weak var colonLabel: UILabel!
    @IBOutlet weak var listSpdLabel: UILabel!
    @IBOutlet weak var soundLabel: UILabel!
    
    
    //App Enters Background
    @objc func willResignActive(_ notification: Notification) {
       /* if let scene = self.scene {
            scene.stopDot()
        }*/
        dotImage.layer.removeAllAnimations()
        
        UIView.animate(withDuration: 0.2, animations: {
            self.unpauseButton.alpha = 1
            self.pauseButton.alpha = 0
            self.stopButton.alpha = 1
            self.secLabel.alpha = 1
            self.minLabel.alpha = 1
            self.colonLabel.alpha = 1
            self.spdLabel.alpha = 1
            self.spdStepper.alpha = 1
            self.soundPicker.alpha = 1
            self.listSpdLabel.alpha = 1
            self.soundLabel.alpha = 1
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
    
    @objc func UpdateTimer() {
        time += 1
        minLabel.text = "\(time / 60)"
        secLabel.text = "\(time % 60)"
    }
    
    var player: AVAudioPlayer?
    
    func playSound() {
        guard let url = Bundle.main.url(forResource: "leftEar", withExtension: "mp3") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            
            /* iOS 10 and earlier require the following line:
             player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */
            
            guard let player = player else { return }
            
            player.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func animateRight()
    {
        UIView.animate(withDuration: 1.8, delay: 0.0, options:[], animations: {
            self.dotImage.center.x = self.dotImage.frame.width/2
            self.dotXConstraint.constant = 0
            self.dotImage.layoutIfNeeded()
        }, completion: { finished in
            if finished {
                self.animateLeft()
            }
        })
    }
    
    func animateLeft()
    {
        UIView.animate(withDuration: 2.0, delay: 0.0, options: [ .autoreverse, .repeat, .curveEaseInOut, .beginFromCurrentState], animations: {
            self.dotImage.frame.origin.x = 0.0
        }, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        
        //App Enters Background
        NotificationCenter.default.addObserver(self, selector: #selector(willResignActive), name: UIApplication.willResignActiveNotification, object: nil)
        
        //Orientation lock
        AppUtility.lockOrientation(.landscape)
        /* MARK: SPRITE KIT SCENE
        self.scene = DotScene(size: CGSize(width: self.sceneView.frame.size.width, height: self.sceneView.frame.size.height))
        self.scene?.scaleMode = .aspectFill
                
        self.sceneView.presentScene(self.scene)
*/

        /*guard let sound = Bundle.main.path(forResource: "leftEar", ofType: "mp3") else { return }
        
        let url = URL(fileURLWithPath: sound)
        
        do {
            
            audioPlayer = try? AVAudioPlayer(contentsOf: url, fileTypeHint: nil)
            audioPlayer?.prepareToPlay()
        }*/
        
        stopWatchTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(UpdateTimer), userInfo: nil, repeats: true)
        
        if(isPlaying) {
            return
        }
        
        isPlaying = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Mark: Setup Dot
        //self.dotImage.center = CGPoint(x: view.frame.midX ,y: view.frame.midY)
        self.dotXConstraint.constant = view.frame.width/2
        self.dotYConstraint = NSLayoutConstraint(item: dotImage, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([dotXConstraint, dotYConstraint])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //Mark: Dot Animation
        //animateRight()
        /*UIView.animate(withDuration: 1.8, delay: 0, options: [], animations: {
            self.dotImage.center.x = self.view.bounds.width - self.dotImage.frame.width
            self.dotXConstraint.constant = self.view.bounds.width - self.dotImage.frame.width
            self.dotImage.layoutIfNeeded()
            Sound.play(file: "leftEar.mp3")
        }) */
        
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
                self.spdLabel.alpha = 0
                self.spdStepper.alpha = 0
                self.soundPicker.alpha = 0
                self.listSpdLabel.alpha = 0
                self.soundLabel.alpha = 0
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
                    self.spdLabel.alpha = 1
                    self.spdStepper.alpha = 1
                    self.soundPicker.alpha = 1
                    self.listSpdLabel.alpha = 1
                    self.soundLabel.alpha = 1
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
                    self.spdLabel.alpha = 1
                    self.spdStepper.alpha = 1
                    self.soundPicker.alpha = 1
                    self.listSpdLabel.alpha = 1
                    self.soundLabel.alpha = 1
                })
            }
        }
    }
    
    @IBAction func pausePressed(_ sender: Any) {
        pausePressed = true
        
        stopWatchTimer.invalidate()
        isPlaying = false
        
        dotImage.layer.removeAllAnimations()
        /*if let scene = self.scene {
            scene.stopDot()
        }*/
        UIView.animate(withDuration: 0.2, animations: {
            self.pauseButton.alpha = 0
            self.unpauseButton.alpha = 1
        })
    }
    
    @IBAction func unpausePressed(_ sender: Any) {
        pausePressed = false
        /*if let scene = self.scene {
            scene.moveDot()        }*/
        UIView.animate(withDuration: 1.8, delay: 0, options: [.repeat, .autoreverse], animations: {
            self.dotImage.center.x = self.view.bounds.width - self.dotImage.frame.width
            self.dotXConstraint.constant = self.view.bounds.width - self.dotImage.frame.width
            self.dotImage.layoutIfNeeded()
        }) /*{ (finished) in
            if finished {
                UIView.animate(withDuration: 1.8, delay: 0, options: [.repeat], animations: {
                    self.dotImage.center.x = self.dotImage.frame.width/2
                    self.dotXConstraint.constant = 0
                    self.dotImage.layoutIfNeeded()
                })
            }
        }*/
        
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
        dotImage.layer.removeAllAnimations()
        /*if let scene = self.scene {
            scene.stopDot()
        }*/
        
        if let id = SessionsDatabase.instance.addSession1(currentDate: currentDate, currentTime: currentTime, time: time) {
            let session = Session(id: id, sessionDate: currentDate, sessionTime: currentTime, duration: time)
            sessions.append(session)
            
        }
        
        performSegue(withIdentifier: "UnwindToMenuSegueID", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Don't forget to reset when view is being removed
        AppUtility.lockOrientation(.all)
        
    }
}
