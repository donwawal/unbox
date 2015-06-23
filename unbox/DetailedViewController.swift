//
//  DetailedViewController.swift
//  unbox
//
//  Created by Jules Walter on 6/13/15.
//  Copyright (c) 2015 Jules Walter. All rights reserved.
//

import UIKit

class DetailedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeContainerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageField: UITextField!
    @IBOutlet weak var sendMessageView: UIView!
    
    var likes: Int!
    var photoUrl: String!
    var photo: UIImage!
    
    var post: PFObject!
    
    var messages: [PFObject] = []
    
    // to animate on like
    var likeButtonCopy = UIImageView()
    var destination: CGPoint!
    var initialFrame: CGRect!
    var destinationFrame: CGRect!
    var photoViewCenter: CGPoint!
    
    var photoUrls:[String] = []
    
    var window = UIApplication.sharedApplication().keyWindow
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // set the cell color to clear
        self.tableView.separatorColor = UIColor(red:0.929,  green:0.929,  blue:0.929, alpha:1)
        
        
        photoView.setImageWithURL(NSURL(string: photoUrl))
        
        if likes == nil {
            likes = 0
        }
        
        likeCountLabel.text = String(likes)
        var imageName = "active_heart"

        //Copy of like Button for animation
        photoViewCenter = CGPoint(x: 160, y: 207)
        
        likeButtonCopy.image = UIImage(named: imageName)
        likeButtonCopy.center = photoViewCenter
        likeButtonCopy.frame.size = likeButtonCopy.image!.size
        likeButtonCopy.alpha = 0
        photoView.addSubview(likeButtonCopy)
        
        destination = photoView.convertPoint(likeButton.center, fromView: likeContainerView)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        var timer = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: "onTimer", userInfo: nil, repeats: true)
        timer.fire()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
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
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
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
    
    //TableView Code
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("MessageCell") as! MessageCell
        
        var message = messages[indexPath.row]
        cell.messageLabel.text = message["text"] as? String
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    @IBAction func didPressSend(sender: UIButton) {
        var message = PFObject(className: "Message")
        message["text"] = messageField.text
        message["user"] = PFUser.currentUser()
        message["post"] = post
        
        message.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            println("message saved")
        }
        self.view.endEditing(true)
        
        messageField.text = ""
    }
    
    func onTimer(){
        var query = PFQuery(className: "Message")
        query.whereKey("post", equalTo: post)
        
        query.findObjectsInBackgroundWithBlock { (results:[AnyObject]?, error: NSError?) -> Void in
            self.messages = results as! [PFObject]
            self.tableView.reloadData()
        }
    }
    
    func keyboardWillShow(notification: NSNotification!) {
        var userInfo = notification.userInfo!
        
        // Get the keyboard height and width from the notification
        // Size varies depending on OS, language, orientation
        var kbSize = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue().size
        var durationValue = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber
        var animationDuration = durationValue.doubleValue
        var curveValue = userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber
        var animationCurve = curveValue.integerValue
        
        UIView.animateWithDuration(animationDuration, delay: 0.0, options: UIViewAnimationOptions(UInt(animationCurve << 16)), animations: {
            
            // Set view properties in here that you want to match with the animation of the keyboard
            // If you need it, you can use the kbSize property above to get the keyboard width and height.
            
            self.photoView.center.y -= kbSize.height
            self.tableView.center.y -= kbSize.height
            self.sendMessageView.center.y -= kbSize.height
            self.likeContainerView.center.y -= kbSize.height
            
            }, completion: nil)
    }
    
    func keyboardWillHide(notification: NSNotification!) {
        var userInfo = notification.userInfo!
        
        // Get the keyboard height and width from the notification
        // Size varies depending on OS, language, orientation
        var kbSize = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue().size
        var durationValue = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber
        var animationDuration = durationValue.doubleValue
        var curveValue = userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber
        var animationCurve = curveValue.integerValue
        
        UIView.animateWithDuration(animationDuration, delay: 0.0, options: UIViewAnimationOptions(UInt(animationCurve << 16)), animations: {
            
            // Set view properties in here that you want to match with the animation of the keyboard
            // If you need it, you can use the kbSize property above to get the keyboard width and height.
            
            self.photoView.center.y += kbSize.height
            self.tableView.center.y += kbSize.height
            self.sendMessageView.center.y += kbSize.height
            self.likeContainerView.center.y += kbSize.height
            
            }, completion: nil)
    }
    
    @IBAction func onTap(sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
}
