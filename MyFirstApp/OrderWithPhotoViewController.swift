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
    var photoURL : URL?
        
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func sendPicture(_ sender: AnyObject) {
        callWatson()
    }

    @IBAction func useCamera(_ sender: AnyObject) {
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func callWatson(){

        let url = NSURL(string: "https://gateway-a.watsonplatform.net/visual-recognition/api/v3/classify?api_key=54a2ea093fbed06393dab35593dc51f785b493c5&version=2016-05-20")
        let request = NSMutableURLRequest(url: url! as URL)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data", forHTTPHeaderField: "content-type")
        request.httpBody = NSData(contentsOf: photoURL!) as Data?
        
        let connection = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            if let urlData = data {
                do {
                    let response = try JSONSerialization.jsonObject(with: urlData, options: JSONSerialization.ReadingOptions.mutableLeaves) as! NSDictionary
                    
                    if let res = response["images"] {
                        let resArr = res as! NSArray
                        
                        if resArr.count > 0 {
                            let classifiersDict = resArr[0] as! NSDictionary
                            let classifiers = classifiersDict["classifiers"] as! NSArray
                            let classesDict = classifiers[0] as! NSDictionary
                            let classes = classesDict["classes"]! as! NSArray
                            let cla = classes[0] as! NSDictionary
                            let classString = cla["class"] as! String
                            
                            DispatchQueue.main.async(execute: { () -> Void in
                                NSLog(classString)
                            })
                        } else {
                            DispatchQueue.main.async(execute: { () -> Void in
                                NSLog("No results found. Please try again.")
                            })
                        }
                    } else {
                        DispatchQueue.main.async(execute: { () -> Void in
                            NSLog("No results found. Please try again2.")
                        })
                    }
                } catch let err as NSError{
                    print(err.localizedDescription)
                }
            } else {
                print(error?.localizedDescription)
                DispatchQueue.main.async(execute: { () -> Void in
                    NSLog(error!.localizedDescription)
                })
            }
        }
        
        connection.resume()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        imagePicker.dismiss(animated: true, completion: nil)
        imageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        if let data = UIImagePNGRepresentation(imageView.image!) {
            let filename = getDocumentsDirectory().appendingPathComponent("temp.jpg")
            try? data.write(to: filename)
            NSLog("%@", "Loading page with URL: \(filename)")
            photoURL = filename
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
}
