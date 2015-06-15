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
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var vc = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        vc.delegate = self
        vc.allowsEditing = true
        vc.sourceType = UIImagePickerControllerSourceType.Camera
        // set my real view
        //vc.cameraOverlayView = cameraView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func imagePickerController(picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
            var originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
            var editedImage = info[UIImagePickerControllerEditedImage]as! UIImage
            
            outputImageView.image = originalImage
            picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func didPressTakePhoto(sender: UIButton) {
        
                self.presentViewController(vc, animated: true, completion: nil)
    }
    
    
    @IBAction func didPressSubmitPhoto(sender: UIButton) {
        //Write parse code here to replace code below
        dismissViewControllerAnimated(true, completion: nil)
        performSegueWithIdentifier("pictureToFeedSegue", sender: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
