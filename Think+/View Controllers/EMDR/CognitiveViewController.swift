//
//  CognitiveViewController.swift
//  Think+
//
//  Created by Nick Wu on 3/26/18.
//  Copyright © 2018 Nick Wu. All rights reserved.
//

import Foundation
import UIKit

class CognitiveViewController: UIViewController {
    
    // The image that we will zoom/drag
    //var imageView = UIImageView()
    @IBOutlet weak var imageView: UIImageView!
    
    // The dark overlay layer behind the image
    // that will be visible while gestures are recognized
    var overlay: UIView = {
        let view = UIView(frame: UIScreen.main.bounds);
        
        view.alpha = 0
        view.backgroundColor = .black
        
        return view
    }()
    
    @IBOutlet weak var labelText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do not forget to enable user interaction on our imageView
        imageView.isUserInteractionEnabled = true
        
        // MARK: - UIGesturesRecognizers
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(self.handleZoom(_:)))
        let pan = UIPanGestureRecognizer(target: self, action: #selector(self.handlePan(_:)))
        
        // Use 2 fingers to move the view
        pan.maximumNumberOfTouches = 2
        pan.minimumNumberOfTouches = 2
        
        // We delegate gestures so we can perform both at the same time
        pan.delegate = self
        pinch.delegate = self
        
        // Add the gestures to our target (imageView)
        imageView.addGestureRecognizer(pinch)
        imageView.addGestureRecognizer(pan)
        
        // Here some basic setup
        view.addSubview(overlay)
        view.bringSubviewToFront(imageView)

        //MARK: Info Button
        let rightButtonItem = UIBarButtonItem(
            title: "?",
            style: .done,
            target: self,
            action: #selector(infoButtonTapped)
        )
        
        self.navigationItem.rightBarButtonItem = rightButtonItem
        
        AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
        
        // Do any additional setup after loading the view.
    }

    /// Setup imageView
    private func setupImageView() {
        
        // Set the image
        imageView.image = UIImage(named: "Cognitions Sheet 1xedit")
        
        // Resize the content
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        
        // That was for testing porpouse only
        // imageView.backgroundColor = .red
        // Constraints
       // setupImageViewConstraints()
    }
    
    /// Setup ImageView constraints
  /*private func setupImageViewConstraints() {
        
        // Disable Autoresizing Masks into Constraints
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        // Constraints
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 250)
            ])
        
        view.layoutIfNeeded()
    }*/

    @objc func infoButtonTapped(sender: UIBarButtonItem) {
        performSegue(withIdentifier: "infoSegue", sender: sender)
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

// MARK: - Extension
extension CognitiveViewController: UIGestureRecognizerDelegate {
    
    // That method make it works
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    @objc func handleZoom(_ gesture: UIPinchGestureRecognizer) {
        switch gesture.state {
        case .began, .changed:
            
            // Only zoom in, not out
            if gesture.scale >= 1 {
                
                // Get the scale from the gesture passed in the function
                let scale = gesture.scale
                
                // use CGAffineTransform to transform the imageView
                gesture.view!.transform = CGAffineTransform(scaleX: scale, y: scale)
            }
            
            
            // Show the overlay
            UIView.animate(withDuration: 0.2) {
                self.overlay.alpha = 0.8
            }
            break;
        default:
            // If the gesture has cancelled/terminated/failed or everything else that's not performing
            // Smoothly restore the transform to the "original"
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
                gesture.view!.transform = .identity
            }) { _ in
                // Hide the overlay
                UIView.animate(withDuration: 0.2) {
                    self.overlay.alpha = 0
                }
            }
        }
    }
    
    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began, .changed:
            // Get the touch position
            let translation = gesture.translation(in: imageView)
            
            // Edit the center of the target by adding the gesture position
            gesture.view!.center = CGPoint(x: imageView.center.x + translation.x, y: imageView.center.y + translation.y)
            gesture.setTranslation(.zero, in: imageView)
            
            // Show the overlay
            UIView.animate(withDuration: 0.2) {
                self.overlay.alpha = 0.8
            }
            break;
        default:
            // If the gesture has cancelled/terminated/failed or everything else that's not performing
            // Smoothly restore the transform to the "original"
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
                gesture.view!.center = self.view.center
                gesture.setTranslation(.zero, in: self.imageView)
            }) { _ in
                // Hide the overaly
                UIView.animate(withDuration: 0.2) {
                    self.overlay.alpha = 0
                }
            }
            break
        }
    }
}
