//
//  PhotoCaptureViewController.swift
//  unbox
//
//  Created by Jules Walter on 6/14/15.
//  Copyright (c) 2015 Jules Walter. All rights reserved.
//

import UIKit

class PhotoCaptureViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    @IBOutlet weak var takePhotoButton: UIButton!
    @IBOutlet weak var outputImageView: UIImageView!
    
    var alpha: CGFloat!
    var vc = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.alpha = alpha
        
        vc.delegate = self
        vc.allowsEditing = true
        vc.sourceType = UIImagePickerControllerSourceType.Camera
    }
    
    override func viewWillAppear(animated: Bool) {
        if alpha == 0 {
            self.presentViewController(vc, animated: true, completion: nil)}
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        alpha = 1
        self.view.alpha = 0
        picker.dismissViewControllerAnimated(true, completion: nil)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
            var originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
            var editedImage = info[UIImagePickerControllerEditedImage]as! UIImage
            
            outputImageView.image = originalImage
            
            alpha = 1
            self.view.alpha = alpha
            picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func didPressTakePhoto(sender: UIButton) {
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    
    @IBAction func didPressSubmitPhoto(sender: UIButton) {
        uploadPhoto(outputImageView.image!)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func didPressCancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func uploadPhoto(image: UIImage){
        var resizedImage = RBResizeImage(image, targetSize: CGSize(width: 320,height: 420))
        
        let imageData = UIImageJPEGRepresentation(resizedImage, 1.0)
        let imageFile = PFFile(data: imageData)
        
        var post = PFObject(className: "Post")
        
        post["imageFile"] = imageFile
        post["user"] = PFUser.currentUser()
        
        post.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            if success {
                println("post saved")
                post["imageUrl"] = imageFile.url
                post.saveInBackgroundWithBlock({ (Bool, error: NSError?) -> Void in
                    if success {
                        println("url saved")
                    } else {
                        println("url not saved")
                    }
                })
            } else {
                println("error \(error)")
            }
        }
    }
    
    func RBResizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        //from hcatlin / RBResizer.swift
        
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSizeMake(size.width * heightRatio, size.height * heightRatio)
        } else {
            newSize = CGSizeMake(size.width * widthRatio,  size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRectMake(0, 0, newSize.width, newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.drawInRect(rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
