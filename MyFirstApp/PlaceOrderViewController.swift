//
//  PlaceOrderViewController.swift
//  MyFirstApp
//
//  Created by Antonino, Victor O. on 22/09/16.
//  Copyright © 2016 Accenture. All rights reserved.
//

import UIKit
import MediaPlayer

class PlaceOrderViewController: UIViewController {
    
    var moviePlayer: MPMoviePlayerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load the video from the app bundle.
        let videoURL: URL = Bundle.main.url(forResource: "video", withExtension: "mp4")!
        
        // Create and configure the movie player.
        self.moviePlayer = MPMoviePlayerController(contentURL: videoURL)
        
        self.moviePlayer.controlStyle = MPMovieControlStyle.none
        self.moviePlayer.scalingMode = MPMovieScalingMode.aspectFill
        
        self.moviePlayer.view.frame = self.view.frame
        self.view .insertSubview(self.moviePlayer.view, at: 0)
        
        self.moviePlayer.play()
        
        // Loop video.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PlaceOrderViewController.loopVideo), name: MPMoviePlayerPlaybackDidFinishNotification, object: self.moviePlayer)
    }
    
    func loopVideo() {
        self.moviePlayer.play()
    }
    
    
}
