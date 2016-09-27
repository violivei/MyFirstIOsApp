//
//  NoClickViewController.swift
//  MyFirstApp
//
//  Created by Antonino, Victor O. on 19/09/16.
//  Copyright © 2016 Accenture. All rights reserved.
//

import UIKit
import SnapTimer
import FirebaseDatabase

class NoClickPurchaseViewController: UIViewController{
 
    @IBOutlet weak var snapTimer: SnapTimerView!
    @IBOutlet weak var pauseButton: UIButton!
    var timer = Timer()
    var total: CGFloat = 0
    var timerPaused: Bool = false
    var db: FIRDatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        scheduledTimerWithTimeInterval()
        snapTimer.addSubview(pauseButton)
    }
    
    @IBAction func pauseOrder(_ sender: AnyObject) {
        
        timerPaused = !timerPaused
        print(timerPaused)
        if(timerPaused){
            pauseButton.setImage(UIImage(named: "pause-icon-selected"), for: UIControlState())
        }else{
            pauseButton.setImage(UIImage(named: "pause-icon"), for: UIControlState())
        }
        
    }
    
    func scheduledTimerWithTimeInterval(){
        // Scheduling timer to Call the function **Countdown** with the interval of 1 seconds
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(NoClickPurchaseViewController.updateCounting), userInfo: nil, repeats: true)
        db = FIRDatabase.database().reference()
    }
    
    func updateCounting(){
        //NSLog("counting..")
         if(!timerPaused){
            total = total + 10
            snapTimer.animateOuterValue(total)
            if(total > 90){
                total = 0
                let post = db.childByAutoId()
                post.setValue(["orderId": "orderId", "name": "name", "product": "product"])
                timer.invalidate()
                if let next = self.storyboard?.instantiateViewController(withIdentifier: "OrderPlaced"){
                    self.present(next, animated: true, completion: nil)
                }
            }
        }
    }

}
