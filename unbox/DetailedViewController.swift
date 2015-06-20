//
//  DetailedViewController.swift
//  unbox
//
//  Created by Jules Walter on 6/13/15.
//  Copyright (c) 2015 Jules Walter. All rights reserved.
//

import UIKit

class DetailedViewController: UIViewController {
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeContainerView: UIView!
    
    var likes: Int!
    var photoUrl: String!
    var photo: UIImage!
    
    var post: PFObject!
    
    // to animate on like
    var likeButtonCopy = UIImageView()
    var destination: CGPoint!
    var initialFrame: CGRect!
    var destinationFrame: CGRect!
    var photoViewCenter: CGPoint!
    
    var photoUrls:[String] = []
    
    var window = UIApplication.sharedApplication().keyWindow

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        photoView.setImageWithURL(NSURL(string: photoUrl))
        
        if likes == nil {
            likes = 0
        }
        
        likeCountLabel.text = String(likes)
        var imageName = "eye_like"

        //Copy of like Button for animation
        photoViewCenter = CGPoint(x: 160, y: 207)
        
        likeButtonCopy.image = UIImage(named: imageName)
        likeButtonCopy.center = photoViewCenter
        likeButtonCopy.frame.size = likeButtonCopy.image!.size
        likeButtonCopy.alpha = 0
        photoView.addSubview(likeButtonCopy)
        
        destination = photoView.convertPoint(likeButton.center, fromView: likeContainerView)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func sharePhoto(sender: UIBarButtonItem) {
        let textToShare = "Here is a great photo from Peek:"
        
        if let url = NSURL(string: photoUrl)
        {
            let objectsToShare = [textToShare, url]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            self.presentViewController(activityVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func clickedLike(sender: UIButton) {
        if likeButton.selected == true{
            likes = likes - 1
            post.incrementKey("likes", byAmount: -1)
            post.saveInBackgroundWithBlock { (Bool, error: NSError?) -> Void in
                if error == nil {
                    println("like decreased")
                }
            }
            updateLikeLabel()
        } else {
            likes = likes + 1
            post.incrementKey("likes", byAmount: 1)
            post.saveInBackgroundWithBlock { (Bool, error: NSError?) -> Void in
                if error == nil {
                    println("like increased")
                }
            }
            animatedLike()
        }
    }
    
    
    @IBAction func didPressBack(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func animatedLike(){
        self.likeButtonCopy.alpha = 1
        
        UIView.animateWithDuration(1, animations: { () -> Void in
            //likeButton
            self.likeButtonCopy.center = self.destination
            
        }) { (Bool) -> Void in
            self.updateLikeLabel()
            self.likeButtonCopy.alpha = 0
            self.likeButtonCopy.center = self.photoViewCenter
        }
    }
    
    func updateLikeLabel(){
        likeButton.selected = !likeButton.selected
        likeCountLabel.text = String(likes)
    }
}
