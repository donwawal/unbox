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
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeContainerView: UIView!
    
    var likes: Int!
    var locationText = ""
    var photoUrl: String!
    

    // to animate on like
    var likeButtonCopy = UIImageView()
    var destination: CGPoint!
    var initialFrame: CGRect!
    var destinationFrame: CGRect!
    var photoViewCenter: CGPoint!
    
    var window = UIApplication.sharedApplication().keyWindow

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        photoView.setImageWithURL(NSURL(string: photoUrl))
        locationLabel.text = locationText
        
        if likes == nil {
            likes = 0
        }
        
        likeCountLabel.text = String(likes)
        var imageName = "Like-25"

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
        let textToShare = "Here is a great photo from Unbox:"
        
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
            updateLikeLabel()
        } else {
            likes = likes + 1
            animatedLike()
        }
        
        //TODO: update Parse
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
