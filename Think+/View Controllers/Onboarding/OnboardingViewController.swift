//
//  OnboardingViewController.swift
//  Think+
//
//  Created by Nick Wu on 2/28/18.
//  Copyright © 2018 Nick Wu. All rights reserved.
//

import UIKit
import paper_onboarding


class OnboardingViewController: UIViewController, PaperOnboardingDataSource, PaperOnboardingDelegate{
    
    //Outlets
    
    @IBOutlet weak var onboardingView: OnboardingView!
    @IBOutlet weak var getStartedButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
        
        onboardingView.dataSource = self
        onboardingView.delegate = self
        onboardingView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(onboardingView)
        view.addSubview(getStartedButton)
        
        
        // add constraints
        for attribute: NSLayoutConstraint.Attribute in [.left, .right, .top, .bottom] {
            let constraint = NSLayoutConstraint(item: onboardingView,
                                                attribute: attribute,
                                                relatedBy: .equal,
                                                toItem: view,
                                                attribute: attribute,
                                                multiplier: 1,
                                                constant: 0)
            view.addConstraint(constraint)
        }
    }

    //PaperOnboarding Data Source
    
    func onboardingItemsCount() -> Int {
        return 4
    }
    
    func onboardingItem(at index: Int) -> OnboardingItemInfo {
        let backgroundColorOne = #colorLiteral(red: 0.8509803922, green: 0.2823529412, blue: 0.3490196078, alpha: 1)
        let backgroundColorTwo = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
        let backgroundColorThree = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
        let backgroundColorFour = #colorLiteral(red: 0.2823529412, green: 0.5333333333, blue: 0.8470588235, alpha: 1)
        
        let titleFont = UIFont(name: "Nunito-Bold", size: 24)!
        let descriptionFont = UIFont(name: "Nunito-Regular", size: 18)!
        
        
        return [
            OnboardingItemInfo(informationImage: #imageLiteral(resourceName: "headphones"),
                               title: "Headphones",
                               description: "Wear headphones during a session for the best effect.",
                               pageIcon: UIImage(),
                               color: backgroundColorOne,
                               titleColor: UIColor.white,
                               descriptionColor: UIColor.white,
                               titleFont: titleFont,
                               descriptionFont: descriptionFont),
            
            OnboardingItemInfo(informationImage: #imageLiteral(resourceName: "thought"),
                               title: "Cognitive Thoughts",
                               description: "Before starting your session, select negative thoughts that you are feeling and turn them into positive thoughts during session.",
                               pageIcon: UIImage(),
                               color: backgroundColorTwo,
                               titleColor: UIColor.white,
                               descriptionColor: UIColor.white,
                               titleFont: titleFont,
                               descriptionFont: descriptionFont),
            
            OnboardingItemInfo(informationImage: #imageLiteral(resourceName: "watch1x"),
                               title: "Follow the Dot",
                               description: "Follow the dot with your eyes and think of traumatic experiences or thoughts that give you anxiety.",
                               pageIcon: UIImage(),
                               color: backgroundColorThree,
                               titleColor: UIColor.white,
                               descriptionColor: UIColor.white,
                               titleFont: titleFont,
                               descriptionFont: descriptionFont),
            
            OnboardingItemInfo(informationImage: #imageLiteral(resourceName: "journalicon"),
                               title: "Journal",
                               description: "Completed sessions are logged in the Log tab.",
                               pageIcon: UIImage(),
                               color: backgroundColorFour,
                               titleColor: UIColor.white,
                               descriptionColor: UIColor.white,
                               titleFont: titleFont,
                               descriptionFont: descriptionFont)
            ][index]
    }
    
    
    //PaperOnboard Delegate
    
    func onboardingConfigurationItem(_ index: OnboardingContentViewItem, index _: Int) {
    }
    
    func onboardingWillTransitonToIndex(_ index: Int) {
        if index == 1
        {
            if (self.getStartedButton.alpha == 1)
            {
                UIView.animate(withDuration: 0.2, animations: {
                    self.getStartedButton.alpha = 0
                })
            }
        }
    }
    
    
    func onboardingDidTransitonToIndex(_ index: Int) {
        if index == 3 {
            UIView.animate(withDuration: 0.2, animations: {
                self.getStartedButton.alpha = 1
            })
        }
    }
    
   
    @IBAction func gotStarted(_ sender: Any) {
        
        let userDefaults = UserDefaults.standard
        
        userDefaults.set(true, forKey: "onboardingComplete")
    
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
}
