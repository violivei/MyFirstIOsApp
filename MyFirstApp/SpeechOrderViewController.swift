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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func runAudioRecorder(_ sender: AnyObject) {
        let controller = AudioRecorderViewController()
        controller.audioRecorderDelegate = self
        present(controller, animated: true, completion: nil)
    }

    func audioRecorderViewControllerDismissed(withFileURL fileURL: NSURL?) {
        // do something with fileURL
        dismiss(animated: true, completion: nil)
    }


}
