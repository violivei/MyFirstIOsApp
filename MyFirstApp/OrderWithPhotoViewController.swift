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
    
    // this is a very verbose version of that function
    // you can shorten it, but i left it as-is for clarity
    // and as an example
    func photoDataToFormData(data:NSData,boundary:String,fileName:String) -> NSData {
        var fullData = NSMutableData()
        
        // 1 - Boundary should start with --
        let lineOne = "--" + boundary + "\r\n"
        fullData.appendData(lineOne.dataUsingEncoding(
            NSUTF8StringEncoding,
            allowLossyConversion: false)!)
        
        // 2
        let lineTwo = "Content-Disposition: form-data; name=\"images_file\"; filename=\"" + fileName + "\"\r\n"
        NSLog(lineTwo)
        fullData.appendData(lineTwo.dataUsingEncoding(
            NSUTF8StringEncoding,
            allowLossyConversion: false)!)
        
        // 3
        let lineThree = "Content-Type: image/jpg\r\n\r\n"
        fullData.appendData(lineThree.dataUsingEncoding(
            NSUTF8StringEncoding,
            allowLossyConversion: false)!)
        
        // 4
        fullData.appendData(data)
        
        // 5
        let lineFive = "\r\n"
        fullData.appendData(lineFive.dataUsingEncoding(
            NSUTF8StringEncoding,
            allowLossyConversion: false)!)
        
        // 6 - The end. Notice -- at the start and at the end
        let lineSix = "--" + boundary + "--\r\n"
        fullData.appendData(lineSix.dataUsingEncoding(
            NSUTF8StringEncoding,
            allowLossyConversion: false)!)
        
        return fullData
    }
    
    func sendFile(
        urlPath:String,
        fileName:String,
        data:NSData){
        
        var url: NSURL = NSURL(string: urlPath)!
        var request1: NSMutableURLRequest = NSMutableURLRequest(URL: url)
        
        request1.HTTPMethod = "POST"
        
        let boundary = generateBoundaryString()
        let fullData = photoDataToFormData(data,boundary:boundary,fileName:fileName)
        
        request1.setValue("multipart/form-data; boundary=" + boundary,
                          forHTTPHeaderField: "Content-Type")
        
        // REQUIRED!
        request1.setValue(String(fullData.length), forHTTPHeaderField: "Content-Length")
        
        request1.HTTPBody = fullData
        request1.HTTPShouldHandleCookies = false
        
        let queue:NSOperationQueue = NSOperationQueue()
        
        do {
            let returnData = try NSURLConnection.sendSynchronousRequest(request1, returningResponse: nil)
            let returnString = NSString(data: returnData, encoding: NSUTF8StringEncoding)
            print("returnString = \(returnString!)")
        }
        catch let  error as NSError {
            print(error.description)
        }
        //NSURLConnection.sendAsynchronousRequest(
        //request1,
        //queue: queue,
        //completionHandler:completionHandler)
    }
    
    func callWatson(){
        
        let url = "https://gateway-a.watsonplatform.net/visual-recognition/api/v3/classify?api_key=54a2ea093fbed06393dab35593dc51f785b493c5&version=2016-05-20"
        //let img = UIImage(contentsOfFile: fullPath)
        let data: NSData = UIImageJPEGRepresentation(imageView.image!, 0.2)!
        
        sendFile(url,
                 fileName:"one.jpg",
                 data:data)
        /*let failure = { (error: NSError) in print(error) }
         NSLog("%@", "SENDING: \(imageFileURL().path!)")
         visualRecognition.classify(imageFileURL(), failure: failure) { classifiedImages in
         print(classifiedImages)
         NSLog("%@", "Result: \(classifiedImages)")
         }*/
        
        /*let str = "https://gateway-a.watsonplatform.net/visual-recognition/api/v3/classify?api_key=54a2ea093fbed06393dab35593dc51f785b493c5&version=2016-05-20"
         let request = NSMutableURLRequest(URL: NSURL(string:str)!)
         request.HTTPMethod = "POST"
         
         let boundary = NSString(format: "---------------------------14737809831466499882746641449")
         
         let contentType = NSString(format: "multipart/form-data; boundary=%@",boundary)
         request.addValue(contentType as String, forHTTPHeaderField: "Content-Type")
         
         let body = NSMutableData()
         let imageData = UIImageJPEGRepresentation(imageView.image!, 0.2)
         // append image data to body
         body.appendData(NSString(format: "\r\n--%@\r\n", boundary).dataUsingEncoding(NSUTF8StringEncoding)!)
         body.appendData(NSString(format:"Content-Disposition: form-data; name=\"%@images_file\"; filename=\"img.jpg\"\\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
         body.appendData(NSString(format: "Content-Type: application/octet-stream\r\n\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
         body.appendData(imageData!)
         body.appendData(NSString(format: "\r\n--%@\r\n", boundary).dataUsingEncoding(NSUTF8StringEncoding)!)
         
         request.HTTPBody = body
         
         do {
         let returnData = try NSURLConnection.sendSynchronousRequest(request, returningResponse: nil)
         let returnString = NSString(data: returnData, encoding: NSUTF8StringEncoding)
         print("returnString = \(returnString!)")
         }
         catch let  error as NSError {
         print(error.description)
         }*/
        
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
