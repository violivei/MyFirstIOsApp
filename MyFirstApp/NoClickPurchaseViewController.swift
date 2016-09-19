//
//  NoClickViewController.swift
//  MyFirstApp
//
//  Created by Antonino, Victor O. on 19/09/16.
//  Copyright © 2016 Accenture. All rights reserved.
//

import UIKit
import CLTimer

class NoClickPurchaseViewController: UIViewController,cltimerDelegate {
    
    
    @IBOutlet weak var timer: CLTimer!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        timer.cltimer_delegate=self
        timer.startTimer(withSeconds: 3, format:.Minutes , mode: .Reverse)
        // timer.showDefaultCountDown=false
    }
    
    @IBAction func stopTimer(sender: AnyObject) {
        timer.stopTimer()
    }
    
    @IBAction func resetTimer(sender: AnyObject) {
        timer.resetTimer()
        
    }
    
    @IBAction func startTimer(sender: AnyObject) {
        timer.startTimer(withSeconds: 3, format:.Minutes , mode: .Reverse)
    }
    
    
    func timerDidStop(time:Int){
        print("Stopped time : ",time)
    }
    
    func timerDidUpdate(time:Int){
        print("updated Time : ",time)
    }
}
