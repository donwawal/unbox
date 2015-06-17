//
//  InitiatePhotoViewController.swift
//  unbox
//
//  Created by Jules Walter on 6/16/15.
//  Copyright (c) 2015 Jules Walter. All rights reserved.
//

import UIKit

class InitiatePhotoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var vc = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        vc.delegate = self
        vc.allowsEditing = true
        vc.sourceType = UIImagePickerControllerSourceType.Camera
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func imagePickerController(picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
            var originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
            var editedImage = info[UIImagePickerControllerEditedImage]as! UIImage
            
            picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        self.presentViewController(vc, animated: true, completion: nil)
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
