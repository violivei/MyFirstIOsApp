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
    @IBOutlet weak var bgImage: UIImageView!
    @IBOutlet weak var productLabel: UILabel!
    var timer = NSTimer()
    var total: CGFloat = 0
    var timerPaused: Bool = false
    var db: FIRDatabaseReference!

    override func viewDidAppear(animated: Bool) {
        total = 0
        snapTimer.animateOuterValue(total)
        timerPaused = false
        scheduledTimerWithTimeInterval()
        snapTimer.addSubview(pauseButton)
        db = FIRDatabase.database().reference()
        if let p = ApplicationProperties.sharedInstance.defaultProduct {
            bgImage.image = UIImage(named:p.productImage!)
            productLabel.text = p.name
        } else {
            if let data = ApplicationProperties.sharedInstance.userDefaults.objectForKey("defaultProduct") as? NSData {
                let unarc = NSKeyedUnarchiver(forReadingWithData: data)
                unarc.setClass(Product.self, forClassName: "Product")
                let p = unarc.decodeObjectForKey("root")
                bgImage.image = UIImage(named:p!.productImage!!)
                productLabel.text = p!.name
            }
        }
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        timerPaused = true
        timer.invalidate()
    }
    
    @IBAction func pauseOrder(_: AnyObject) {
        
        timerPaused = !timerPaused
        print(timerPaused)
        if(timerPaused){
            pauseButton.setImage(UIImage(named: "pause-icon-selected"), forState: UIControlState())
        }else{
            pauseButton.setImage(UIImage(named: "pause-icon"), forState: UIControlState())
        }
        
    }
    
    func scheduledTimerWithTimeInterval(){
        // Scheduling timer to Call the function **Countdown** with the interval of 1 seconds
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(NoClickPurchaseViewController.updateCounting), userInfo: nil, repeats: true)
        //db = FIRDatabase.database().reference()
    }
    
    func updateCounting(){
        //NSLog("counting..")
         if(!timerPaused){
            total = total + 10
            snapTimer.animateOuterValue(total)
            if(total > 90){
                total = 0
                let post = db.childByAutoId()
                let qty = Int(arc4random_uniform(6) + 1)
                if let p = ApplicationProperties.sharedInstance.defaultProduct {
                    post.setValue(["name": p.name!, "qty": qty, "productImage": p.productImage!, "cellImage": p.cellImage!])
                }
                timer.invalidate()
                
                let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("OrderPlaced") as UIViewController
                // .instantiatViewControllerWithIdentifier() returns AnyObject! this must be downcast to utilize it
                
                self.presentViewController(viewController, animated: true, completion: nil)
                
            }
        }
    }

}
