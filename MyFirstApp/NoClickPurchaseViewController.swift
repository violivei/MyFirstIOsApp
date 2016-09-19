//
//  NoClickViewController.swift
//  MyFirstApp
//
//  Created by Antonino, Victor O. on 19/09/16.
//  Copyright © 2016 Accenture. All rights reserved.
//

import UIKit
import SnapTimer

class NoClickPurchaseViewController: UIViewController{
 
    @IBOutlet weak var snapTimer: SnapTimerView!
    var timer = NSTimer()
    var total: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scheduledTimerWithTimeInterval()

    }
    
    func scheduledTimerWithTimeInterval(){
        // Scheduling timer to Call the function **Countdown** with the interval of 1 seconds
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(NoClickPurchaseViewController.updateCounting), userInfo: nil, repeats: true)

    }
    
    
    func updateCounting(){
        NSLog("counting..")
        total = total + 10
        snapTimer.animateOuterValue(total)
        if(total > 90){
            timer.invalidate()
        }
    }

}
