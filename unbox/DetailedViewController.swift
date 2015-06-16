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
    @IBOutlet weak var likesCountLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    
    var likes: Int!
    var likeButtonCopy = UIImageView()
    var locationText = ""
    var photoUrl: String!

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
        var photoViewCenter = CGPoint(x: 160, y: 207)
        
        likeButtonCopy.image = UIImage(named: imageName)
        likeButtonCopy.center = photoViewCenter
        likeButtonCopy.frame.size = likeButtonCopy.image!.size
        photoView.addSubview(likeButtonCopy)
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
    }
    
    func animatedLike(){
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            //likeButton
            self.likeButtonCopy.frame = self.likeButton.frame
            
        }) { (Bool) -> Void in
            self.updateLikeLabel()
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
