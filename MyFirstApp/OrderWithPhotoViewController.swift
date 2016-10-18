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
    let visualRecognition = VisualRecognition(apiKey: "54a2ea093fbed06393dab35593dc51f785b493c5", version: "2016-05-20")
    
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
        NSLog("%@", "SENDING: \(imageFileURL().path!)")
        visualRecognition.classify(imageFileURL(), failure: failure) { classifiedImages in
            print(classifiedImages)
            NSLog("%@", "Result: \(classifiedImages)")
        }
        
        /*let url = NSURL(string: "https://gateway-a.watsonplatform.net/visual-recognition/api/v3/classify?api_key=54a2ea093fbed06393dab35593dc51f785b493c5&version=2016-05-20")
        let request = NSMutableURLRequest(URL: url! as NSURL)
        request.HTTPMethod = "POST"
        
        let boundary = generateBoundaryString()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        let body = NSMutableData()
        
        //let fname = "temp.jpg"
        //let mimetype = "image/jpg"
        
        let imageData : UIImage?
        var image_data : NSData?
        
        if let data = NSData(contentsOfURL: photoURL!) {
            imageData = UIImage(data: data as NSData)
            image_data = UIImageJPEGRepresentation(imageData!, 0.2)
        }
        
        body.appendData("--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        //body.append("Content-Disposition:form-data; name=\"test\"\r\n\r\n".data(using: String.Encoding.utf8)!)
        //body.append("hi\r\n".data(using: String.Encoding.utf8)!)
        
        //body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.appendData("Content-Disposition:form-data; name=\"images_file\"; filename=\"\"\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData(image_data!.base64EncodedDataWithOptions(NSDataBase64EncodingOptions()))
        body.appendData("Content-Type:\n\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        //body.append("\n\n".data(using: String.Encoding.utf8)!)
        
        body.appendData("--\(boundary)--\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        request.HTTPBody = body as NSData
        
        //request.httpBody = image_data
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request)
            {(data, response, error) in
            
            guard let _:NSData = data, let _:NSURLResponse = response where error == nil else {
                print("error")
                return
            }
            
            let dataString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            
            print(dataString)            
        }
        task.resume()*/
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        //saveImageToFile
        imageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        saveImageToFile(imageView.image!)
        //let jpegImage = UIImageJPEGRepresentation(imageView.image!, 0.2)
        //jpegImage!.writeToFile(imageFileURL().path!, atomically: true)
        /*jpegImage!.writeToFile(imageFileURL().path!, atomically: true)
        if let data = UIImageJPEGRepresentation(imageView.image!, 1.0) {
            let filename = getDocumentsDirectory().URLByAppendingPathComponent("temp.jpg")
            data.writeToFile((filename?.absoluteString)!, atomically: true)
            NSLog("%@", "Loading page with URL: \(filename)")
            photoURL = filename
        }*/
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    func saveImageToFile(image: UIImage) {
        let applicationSupportDir = NSFileManager.defaultManager().URLsForDirectory(.ApplicationSupportDirectory, inDomains: .UserDomainMask).first!
        let fileManager = NSFileManager.defaultManager()
        if !fileManager.fileExistsAtPath(applicationSupportDir.path!) {
            do {
                try fileManager.createDirectoryAtURL(applicationSupportDir, withIntermediateDirectories: true, attributes: nil)
            }
            catch let err { print(err) }
        }
        
        let resizedImage = resizeImage(image, targetSize: CGSize(width: 1024, height: 768))
        let jpegImage = UIImageJPEGRepresentation(resizedImage!, 0.8)
        jpegImage!.writeToFile(imageFileURL().path!, atomically: true)
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage?
    {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSizeMake(size.width * heightRatio, size.height * heightRatio)
        } else {
            newSize = CGSizeMake(size.width * widthRatio,  size.height * widthRatio)
        }
        
        let rect = CGRectMake(0, 0, newSize.width, newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.drawInRect(rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    func imageFileURL() -> NSURL {
        return NSFileManager.defaultManager().URLsForDirectory(.ApplicationSupportDirectory, inDomains: .UserDomainMask).first!.URLByAppendingPathComponent("image.jpg")!
    }
    
    func getDocumentsDirectory() -> NSURL {
       let paths = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)

        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
}
