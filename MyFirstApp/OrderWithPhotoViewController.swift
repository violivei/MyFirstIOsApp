//
//  OrderWithPhotoViewController.swift
//  MyFirstApp
//
//  Created by Antonino, Victor O. on 22/09/16.
//  Copyright © 2016 Accenture. All rights reserved.
//

import UIKit
import MobileCoreServices
import VisualRecognitionV3

class OrderWithPhotoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var imageView: UIImageView!
    var imagePicker: UIImagePickerController!
    let apiKey = "54a2ea093fbed06393dab35593dc51f785b493c5"
    let version = "2016-09-23"
    var photoURL : String = ""
        
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func sendPicture(_ sender: AnyObject) {
        //let visualRecognition = VisualRecognition(apiKey: apiKey, version: version)
        //let url = "your-image-url"
        //let failure = { (error: NSError) in print(error) }
        //visualRecognition.classify(url: photoURL, failure: failure) { classifiedImages in
            //print(classifiedImages)
        //}
    }

    @IBAction func useCamera(_ sender: AnyObject) {
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        imageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        let imageUrl = info[UIImagePickerControllerReferenceURL] as! NSURL
        let imageName = imageUrl.lastPathComponent
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first as String!
        let photoURL = NSURL(fileURLWithPath: documentDirectory!)
        let localPath = photoURL.appendingPathComponent(imageName!)
        print(photoURL)
    }
    
}
