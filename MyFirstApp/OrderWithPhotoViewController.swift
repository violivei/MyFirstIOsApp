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
    var apiKey: String = "54a2ea093fbed06393dab35593dc51f785b493c5"
    var version: String = "2016-09-23"
    var photoURL: NSURL?
    let visualRecognition = VisualRecognition(apiKey: "54a2ea093fbed06393dab35593dc51f785b493c5", version: "2016-05-19")
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func sendPicture(_: AnyObject) {
        callWatson()
    }

    @IBAction func useCamera(_: AnyObject) {
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .Camera
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func generateBoundaryString() -> String
    {
        return "Boundary-\(NSUUID().UUIDString)"
    }
    
    func callWatson(){
        
        let failure = { (error: NSError) in print(error) }
        NSLog("%@", "SENDING: \(photoURL!)")
        visualRecognition.classify(photoURL!, failure: failure) { classifiedImages in
            print(classifiedImages)
            NSLog("%@", "Result: \(classifiedImages)")
        }
        
        /*let url = NSURL(string: "http://192.168.254.21:3030/classify?api_key=54a2ea093fbed06393dab35593dc51f785b493c5&version=2016-05-20")
        let request = NSMutableURLRequest(url: url! as URL)
        request.httpMethod = "POST"
        
        let boundary = generateBoundaryString()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        let body = NSMutableData()
        
        //let fname = "temp.jpg"
        //let mimetype = "image/jpg"
        
        let imageData : UIImage?
        var image_data : Data?
        
        if let data = NSData(contentsOf: photoURL!) {
            imageData = UIImage(data: data as Data)
            image_data = UIImageJPEGRepresentation(imageData!, 1.0)
        }
        
        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        //body.append("Content-Disposition:form-data; name=\"test\"\r\n\r\n".data(using: String.Encoding.utf8)!)
        //body.append("hi\r\n".data(using: String.Encoding.utf8)!)
        
        //body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Disposition:form-data; name=\"images_file\"; filename=\"\"\n".data(using: String.Encoding.utf8)!)
        body.append(image_data!.base64EncodedData())
        body.append("Content-Type:\n\n".data(using: String.Encoding.utf8)!)
        //body.append("\n\n".data(using: String.Encoding.utf8)!)
        
        body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
        
        request.httpBody = body as Data
        
        //request.httpBody = image_data
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {            (
            data, response, error) in
            
            guard let _:Data = data, let _:URLResponse = response  , error == nil else {
                print("error")
                return
            }
            
            let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            
            print(dataString)            
        }
        task.resume()*/
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        imageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        if let data = UIImageJPEGRepresentation(imageView.image!, 1.0) {
            let filename = getDocumentsDirectory().URLByAppendingPathComponent("temp.jpg")
            data.writeToFile((filename?.absoluteString)!, atomically: true)
            NSLog("%@", "Loading page with URL: \(filename)")
            photoURL = filename
        }
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func getDocumentsDirectory() -> NSURL {
       let paths = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)

        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
}
