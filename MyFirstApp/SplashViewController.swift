//
//  SplashViewController.swift
//  MyFirstApp
//
//  Created by Antonino, Victor O. on 16/09/16.
//  Copyright © 2016 Accenture. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addBackgroundImage()
        //addLogo()
        
        // Show the home screen after a bit. Calls the show() function.
        _ = NSTimer.scheduledTimerWithTimeInterval(2.5, target: self, selector: #selector(SplashViewController.show), userInfo: nil, repeats: false)
    }
    
    /*
     * Gets rid of the status bar
     */
    override func prefersStatusBarHidden() -> Bool {
    return true
    }
    
    /*
     * Shows the app's main home screen.
     * Gets called by the timer in viewDidLoad()
     */
    func show() {
        self.performSegueWithIdentifier("showApp", sender: self)
    }
    
    /*
     * Adds background image to the splash screen
     */
    func addBackgroundImage() {
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        
        let bg = UIImage(named: "splash.jpg")
        let bgView = UIImageView(image: bg)
        
        bgView.frame = CGRectMake(0, 0, screenSize.width, screenSize.height)
        self.view.addSubview(bgView)
    }
    
    /*
     * Adds logo to splash screen
     */
    func addLogo() {
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        
        let logo     = UIImage(named: "logo.png")
        let logoView = UIImageView(image: logo)
        
        let w = logo?.size.width
        let h = logo?.size.height
        
        logoView.frame = CGRectMake( (screenSize.width/2) - (w!/2), 5, w!, h! )
        self.view.addSubview(logoView)
    }
}
