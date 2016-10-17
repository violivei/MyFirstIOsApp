//
//  AudioRecorderViewController.swift
//  AudioRecorderViewControllerExample
//
//  Created by Antonino, Victor O. on 13/09/16.
//  Copyright © 2016 Accenture. All rights reserved.
//

import UIKit
import AVFoundation

protocol AudioRecorderViewControllerDelegate: class {
    func audioRecorderViewControllerDismissed(withFileURL fileURL: NSURL?)
}


class AudioRecorderViewController: UINavigationController {
    
    internal let childViewController = AudioRecorderChildViewController()
    weak var audioRecorderDelegate: AudioRecorderViewControllerDelegate?
<<<<<<< Updated upstream
    var statusBarStyle: UIStatusBarStyle = .Default
=======
    var statusBarStyle: UIStatusBarStyle = UIStatusBarStyle.Default
>>>>>>> Stashed changes
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        statusBarStyle = UIApplication.sharedApplication().statusBarStyle
        UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.sharedApplication().setStatusBarStyle(statusBarStyle, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.0/255.0, green: 46.0/255.0, blue: 16.0/255.0, alpha: 1)
        childViewController.audioRecorderDelegate = audioRecorderDelegate
        viewControllers = [childViewController]
        
<<<<<<< Updated upstream
        navigationBar.barTintColor = UIColor.black
        navigationBar.tintColor = UIColor.white
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        navigationBar.setBackgroundImage(UIImage(), for: .Default)
=======
        navigationBar.barTintColor = UIColor.blackColor()
        navigationBar.tintColor = UIColor.whiteColor()
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
>>>>>>> Stashed changes
    }

   /// override func preferredStatusBarStyle() -> UIStatusBarStyle {
   //     return .lightContent
   // }
    
    
    
    // MARK: AudioRecorderChildViewController
    
    internal class AudioRecorderChildViewController: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
        
        var saveButton: UIBarButtonItem!
        
        @IBOutlet weak var timeLabel: UILabel!
        @IBOutlet weak var recordButton: UIButton!
        
        @IBOutlet weak var recordButtonContainer: UIView!
        
        @IBOutlet weak var playButton: UIButton!
        weak var audioRecorderDelegate: AudioRecorderViewControllerDelegate?

        var timeTimer: NSTimer?
        var milliseconds: Int = 0
        
        var recorder: AVAudioRecorder!
        var player: AVAudioPlayer?
        var outputURL: NSURL
        
        init() {
            let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
            let outputPath = documentsPath.stringByAppendingPathComponent("\(NSUUID().UUIDString).L16")
            outputURL = NSURL(fileURLWithPath: outputPath)
            super.init(nibName: "AudioRecorderViewController", bundle: nil)
        }

        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func viewDidLoad() {
            title = "Gravador"
            //navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(AudioRecorderChildViewController.dismiss(sender:)))
            edgesForExtendedLayout = .Top
            view.backgroundColor = UIColor(red: 0.0/255.0, green: 46.0/255.0, blue: 16.0/255.0, alpha: 1)
            
            saveButton = UIBarButtonItem(title: "Fazer Pedido", style: .Plain, target: self, action: #selector(AudioRecorderChildViewController.saveAudio(_:)))
            navigationItem.rightBarButtonItem = saveButton
            saveButton.enabled = false
            
            let settings = [AVFormatIDKey: NSNumber(unsignedInt: kAudioFormatMPEG4AAC), AVSampleRateKey: NSNumber(unsignedInt: 44100), AVNumberOfChannelsKey: NSNumber(unsignedInt: 2)]
            try! recorder = AVAudioRecorder(URL: outputURL, settings: settings)
          
            recorder.delegate = self
            recorder.prepareToRecord()
            
            recordButton.layer.cornerRadius = 4
            recordButtonContainer.layer.cornerRadius = 25
            recordButtonContainer.layer.borderColor = UIColor.whiteColor().CGColor
            recordButtonContainer.layer.borderWidth = 3
        }
        
        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            
            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord)
                try AVAudioSession.sharedInstance().setActive(true)
            }
            catch let error as NSError {
                NSLog("Error: \(error)")
            }
            
<<<<<<< Updated upstream
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AudioRecorderChildViewController.stopRecording(_:)), name: UIApplicationDidEnterBackgroundNotification, object: nil)
=======
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AudioRecorderChildViewController.stopRecording(_:)), name:UIApplicationDidEnterBackgroundNotification, object: nil)
>>>>>>> Stashed changes
        }
        
        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            NSNotificationCenter.defaultCenter().removeObserver(self)
        }
        
        func dismiss(sender: AnyObject) {
            cleanup()
            audioRecorderDelegate?.audioRecorderViewControllerDismissed(withFileURL: nil)
        }
        
        func saveAudio(sender: AnyObject) {
            cleanup()
            audioRecorderDelegate?.audioRecorderViewControllerDismissed(withFileURL: outputURL)
            callWatson()
        }
        
        @IBAction func toggleRecord(_ sender: AnyObject) {

            timeTimer?.invalidate()
            
            if recorder.recording {
                recorder.stop()
            } else {
                milliseconds = 0
                timeLabel.text = "00:00.00"
                timeTimer = NSTimer.scheduledTimerWithTimeInterval(0.0167, target: self, selector: #selector(AudioRecorderChildViewController.updateTimeLabel(_:)), userInfo: nil, repeats: true)
                recorder.deleteRecording()
                recorder.record()
            }
            
            updateControls()
        }
        
        func stopRecording(sender: AnyObject) {
            if recorder.recording {
                toggleRecord(sender)
            }
        }
        
        func cleanup() {
            timeTimer?.invalidate()
            if recorder.recording {
                recorder.stop()
                recorder.deleteRecording()
            }
            if let player = player {
                player.stop()
                self.player = nil
            }
        }
        
        @IBAction func play(_ sender: AnyObject) {
            
            if let player = player {
                player.stop()
                self.player = nil
                updateControls()
                return
            }
            
            do {
                try player = AVAudioPlayer(contentsOfURL: outputURL)
            }
            catch let error as NSError {
                NSLog("error: \(error)")
            }
            
            player?.delegate = self
            player?.play()
            
            updateControls()
        }
        
        
        func updateControls() {
            
            UIView.animateWithDuration(0.2) { () -> Void in
                //self.recordButton.transform = self.recorder.recording ? CGAffineTransform(scaleX: 0.5, y: 0.5) : CGAffineTransform(scaleX: 1, y: 1)
            }
            
            if let _ = player {
                playButton.setImage(UIImage(named: "StopButton"), forState: .Normal)
                recordButton.enabled = false
                recordButtonContainer.alpha = 0.25
            } else {
                playButton.setImage(UIImage(named: "PlayButton"), forState: .Normal)
                recordButton.enabled = true
                recordButtonContainer.alpha = 1
            }
            
            playButton.enabled = !recorder.recording
            playButton.alpha = recorder.recording ? 0.25 : 1
            saveButton.enabled = !recorder.recording
            
        }
        
        
        
        
        // MARK: Time Label
        
        func updateTimeLabel(timer: NSTimer) {
            milliseconds += 1
            let milli = (milliseconds % 60) + 39
            let sec = (milliseconds / 60) % 60
            let min = milliseconds / 3600
            timeLabel.text = NSString(format: "%02d:%02d.%02d", min, sec, milli) as String
        }
        
        
        // MARK: Playback Delegate
        
        func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
            self.player = nil
            updateControls()
        }
        
        func callWatson(){
            //spinner.hidden = false
            //spinner.startAnimating()
            //resultTextLabel.text = ""
            
            // set up the base64-encoded credentials
            let loginString = NSString(format: "%@:%@", "4f6fb20f-e858-434d-b006-5cd400e099c6", "OY3Eh2YKewh4")
            let loginData: NSData = loginString.dataUsingEncoding(NSUTF8StringEncoding)!
            let base64LoginString = loginData.base64EncodedDataWithOptions(NSDataBase64EncodingOptions())
            
            let url = NSURL(string: "https://stream.watsonplatform.net/speech-to-text/api/v1/recognize")
            let request = NSMutableURLRequest(URL: url!)
            request.HTTPMethod = "POST"
            request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
            request.setValue("audio/l16;rate=44100; channels=2", forHTTPHeaderField: "content-type")
            
            let inputData : NSURL? = outputURL.absoluteURL
            let absoluteURL = inputData?.absoluteURL
            
            NSLog((absoluteURL?.absoluteString)!)
            
            request.HTTPBody = NSData(contentsOfURL: absoluteURL!)
            
            let connection = NSURLSession.sharedSession().dataTaskWithURL(url!) { (data, response, error) -> Void in
                if let urlData = data {
                    do {
                        let response = try NSJSONSerialization.JSONObjectWithData(urlData, options: .MutableLeaves) as! NSDictionary
                        
                        if let res = response["results"] {
                            let resArr = res as! NSArray
                            
                            if resArr.count > 0 {
                                let firstRes = resArr[0] as! NSDictionary
                                let alts = firstRes["alternatives"] as! NSArray
                                let firstAlt = alts[0] as! NSDictionary
                                let text = firstAlt["transcript"]! as! String
                                let confidence = firstAlt["confidence"] as! Float
                                
                                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                    //self.resultTextLabel.text = text
                                    //self.spinner.hidden = true
                                    //self.spinner.stopAnimating()
                                    
                                    if confidence > 0.6 {
                                        NSLog(text)
                                    } else {
                                        NSLog(text)
                                    }
                                })
                            } else {
                                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                    //self.resultTextLabel.text = "No results found. Please try again."
                                    //self.resultTextLabel.textColor = UIColor.redColor()
                                    //self.spinner.hidden = true
                                    //self.spinner.stopAnimating()
                                    NSLog("No results found. Please try again.")
                                })
                            }
                        } else {
                           dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                NSLog("No results found. Please try again2.")
                                //self.resultTextLabel.text = "No results found. Please try again."
                                //self.resultTextLabel.textColor = UIColor.redColor()
                                //self.spinner.hidden = true
                                //self.spinner.stopAnimating()
                            })
                        }
                    } catch let err as NSError{
                        print(err.localizedDescription)
                    }
                } else {
                    print(error?.localizedDescription)
                    dispatch_async(dispatch_get_main_queue(),{ () -> Void in
                        //self.resultTextLabel.text = error!.localizedDescription
                        //self.resultTextLabel.textColor = UIColor.redColor()
                        //self.spinner.hidden = true
                        //self.spinner.stopAnimating()
                        NSLog(error!.localizedDescription)
                    })
                }
            }
            
            connection.resume()
        }
        
    }

}

