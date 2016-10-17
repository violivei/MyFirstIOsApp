//
//  SpeechOrderViewController.swift
//  MyFirstApp
//
//  Created by Antonino, Victor O. on 28/09/16.
//  Copyright © 2016 Accenture. All rights reserved.
//

import UIKit

class SpeechOrderViewController: UIViewController, AudioRecorderViewControllerDelegate {

    @IBOutlet weak var urlLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let controller = AudioRecorderViewController()
        controller.audioRecorderDelegate = self
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func audioRecorderViewControllerDismissed(withFileURL fileURL: NSURL?) {
        // do something with fileURL
        dismissViewControllerAnimated(true, completion: nil)
    }


}
