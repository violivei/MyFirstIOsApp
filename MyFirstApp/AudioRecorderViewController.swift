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
    var statusBarStyle: UIStatusBarStyle = .default
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        statusBarStyle = UIApplication.shared.statusBarStyle
        UIApplication.shared.setStatusBarStyle(.lightContent, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.setStatusBarStyle(statusBarStyle, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.0/255.0, green: 46.0/255.0, blue: 16.0/255.0, alpha: 1)
        childViewController.audioRecorderDelegate = audioRecorderDelegate
        viewControllers = [childViewController]
        
        navigationBar.barTintColor = UIColor.black
        navigationBar.tintColor = UIColor.white
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        navigationBar.setBackgroundImage(UIImage(), for: .default)
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

        var timeTimer: Timer?
        var milliseconds: Int = 0
        
        var recorder: AVAudioRecorder!
        var player: AVAudioPlayer?
        var outputURL: NSURL
        
        init() {
            let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
            let outputPath = documentsPath.appendingPathComponent("\(NSUUID().uuidString).m4a")
            outputURL = NSURL(fileURLWithPath: outputPath)
            super.init(nibName: "AudioRecorderViewController", bundle: nil)
        }

        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func viewDidLoad() {
            title = "Gravador"
            //navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(AudioRecorderChildViewController.dismiss(sender:)))
            edgesForExtendedLayout = .top
            view.backgroundColor = UIColor(red: 0.0/255.0, green: 46.0/255.0, blue: 16.0/255.0, alpha: 1)
            
            saveButton = UIBarButtonItem(title: "Fazer Pedido", style: .plain, target: self, action: #selector(AudioRecorderChildViewController.saveAudio(sender:)))
            navigationItem.rightBarButtonItem = saveButton
            saveButton.isEnabled = false

            let settings = [AVFormatIDKey: NSNumber(value: kAudioFormatMPEG4AAC), AVSampleRateKey: NSNumber(value: 44100), AVNumberOfChannelsKey: NSNumber(value: 2)]
            try! recorder = AVAudioRecorder(url: outputURL as URL, settings: settings)
            recorder.delegate = self
            recorder.prepareToRecord()
            
            recordButton.layer.cornerRadius = 4
            recordButtonContainer.layer.cornerRadius = 25
            recordButtonContainer.layer.borderColor = UIColor.white.cgColor
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
            
            NotificationCenter.default.addObserver(self, selector: #selector(AudioRecorderChildViewController.stopRecording(sender:)), name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
        }
        
        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            NotificationCenter.default.removeObserver(self)
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
            
            if recorder.isRecording {
                recorder.stop()
            } else {
                milliseconds = 0
                timeLabel.text = "00:00.00"
                timeTimer = Timer.scheduledTimer(timeInterval: 0.0167, target: self, selector: #selector(AudioRecorderChildViewController.updateTimeLabel(timer:)), userInfo: nil, repeats: true)
                recorder.deleteRecording()
                recorder.record()
            }
            
            updateControls()
        }
        
        func stopRecording(sender: AnyObject) {
            if recorder.isRecording {
                toggleRecord(sender)
            }
        }
        
        func cleanup() {
            timeTimer?.invalidate()
            if recorder.isRecording {
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
                try player = AVAudioPlayer(contentsOf: outputURL as URL)
            }
            catch let error as NSError {
                NSLog("error: \(error)")
            }
            
            player?.delegate = self
            player?.play()
            
            updateControls()
        }
        
        
        func updateControls() {
            
            UIView.animate(withDuration: 0.2) { () -> Void in
                self.recordButton.transform = self.recorder.isRecording ? CGAffineTransform(scaleX: 0.5, y: 0.5) : CGAffineTransform(scaleX: 1, y: 1)
            }
            
            if let _ = player {
                playButton.setImage(UIImage(named: "StopButton"), for: .normal)
                recordButton.isEnabled = false
                recordButtonContainer.alpha = 0.25
            } else {
                playButton.setImage(UIImage(named: "PlayButton"), for: .normal)
                recordButton.isEnabled = true
                recordButtonContainer.alpha = 1
            }
            
            playButton.isEnabled = !recorder.isRecording
            playButton.alpha = recorder.isRecording ? 0.25 : 1
            saveButton.isEnabled = !recorder.isRecording
            
        }
        
        
        
        
        // MARK: Time Label
        
        func updateTimeLabel(timer: Timer) {
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
            let loginString = NSString(format: "%@:%@", "9cace614-b956-4432-984c-d4301df752c2", "LzVpNBzUQ28Z")
            let loginData: NSData = loginString.data(using: String.Encoding.utf8.rawValue)! as NSData
            let base64LoginString = loginData.base64EncodedString(options: NSData.Base64EncodingOptions.init(rawValue: 0))
            
            let url = NSURL(string: "https://stream.watsonplatform.net/speech-to-text/api/v1/recognize")
            let request = NSMutableURLRequest(url: url! as URL)
            request.httpMethod = "POST"
            request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
            request.setValue("audio/l16;rate=16000", forHTTPHeaderField: "content-type")
            
            request.httpBody = NSData(contentsOf: outputURL.baseURL!) as Data?
            
            let connection = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
                if let urlData = data {
                    do {
                        let response = try JSONSerialization.jsonObject(with: urlData, options: JSONSerialization.ReadingOptions.mutableLeaves) as! NSDictionary
                        
                        if let res = response["results"] {
                            let resArr = res as! NSArray
                            
                            if resArr.count > 0 {
                                let firstRes = resArr[0] as! NSDictionary
                                let alts = firstRes["alternatives"] as! NSArray
                                let firstAlt = alts[0] as! NSDictionary
                                let text = firstAlt["transcript"]! as! String
                                let confidence = firstAlt["confidence"] as! Float
                                
                                DispatchQueue.main.async(execute: { () -> Void in
                                    //self.resultTextLabel.text = text
                                    //self.spinner.hidden = true
                                    //self.spinner.stopAnimating()
                                    
                                    if confidence > 0.6 {
                                        print(text)
                                    } else {
                                        print(text)
                                    }
                                })
                            } else {
                                DispatchQueue.main.async(execute: { () -> Void in
                                    //self.resultTextLabel.text = "No results found. Please try again."
                                    //self.resultTextLabel.textColor = UIColor.redColor()
                                    //self.spinner.hidden = true
                                    //self.spinner.stopAnimating()
                                })
                            }
                        } else {
                            DispatchQueue.main.async(execute: { () -> Void in
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
                    DispatchQueue.main.async(execute: { () -> Void in
                        //self.resultTextLabel.text = error!.localizedDescription
                        //self.resultTextLabel.textColor = UIColor.redColor()
                        //self.spinner.hidden = true
                        //self.spinner.stopAnimating()
                    })
                }
            }
            
            connection.resume()
        }
        
    }

}

