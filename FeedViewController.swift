//
//  FeedViewController.swift
//  unbox
//
//  Created by Jules Walter on 6/13/15.
//  Copyright (c) 2015 Jules Walter. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var photos: NSArray! = []
    var photoUrls:[String] = []
    var posts:[PFObject] = []
    
    var images: NSArray! = []
    var outputImageView = UIImageView()
    var selectedImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
//        var timer = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: "onTimer", userInfo: nil, repeats: true)
//        timer.fire()
        
        // Launch Instagram
        var clientId = "da5916311f2a4d0fb0f6d5ee0f5034bb"
        var url = NSURL(string: "https://api.instagram.com/v1/media/popular?client_id=\(clientId)")!
        
        var request = NSURLRequest(URL: url)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            var responseDictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as! NSDictionary
            self.photos = responseDictionary["data"] as! NSArray
            self.tableView.reloadData()
        }
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
        //return posts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("PhotoCell") as! PhotoCell
        
        // comment out to get parse photos
        var photo = photos[indexPath.row] as! NSDictionary
        var photoUrl = photo.valueForKeyPath("images.low_resolution.url") as? String
        photoUrls.append(photoUrl!)
        cell.photoView.setImageWithURL(NSURL(string: photoUrl!))
        
        // comment out to get instagram photos
//        var post = posts[indexPath.row] as PFObject
//        var photoUrl = post["imageUrl"] as! String
//        
//
//        var imageFile = post["imageFile"] as! PFFile
//        
//        imageFile.getDataInBackgroundWithBlock {
//            (imageData: NSData?, error: NSError?) -> Void in
//            if error == nil {
//                if let imageData = imageData {
//                    let image = UIImage(data:imageData)
//                    cell.photoView.image! = image!
//                }
//            }
//        }
        
        return cell
    }
    
//    func downloadInstagramInCell(cell: PhotoCell, indexPath: NSIndexPath) -> PhotoCell{
//        var photo = photos[indexPath.row] as! NSDictionary
//        var photoUrl = photo.valueForKeyPath("images.low_resolution.url") as? String
//        photoUrls.append(photoUrl!)
//        cell.photoView.setImageWithURL(NSURL(string: photoUrl!))
//        return cell
//        
//    }
//    
//    func downloadParseInCell(cell: PhotoCell, indexPath: NSIndexPath) -> PhotoCell {
//        var post = posts[indexPath.row] as PFObject
//        var photoUrl = post["imageUrl"] as? String
//        photoUrls.append(photoUrl!)
//        cell.photoView.setImageWithURL(NSURL(string: photoUrl!))
//        return cell
//    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("detailedViewSegue", sender: tableView.cellForRowAtIndexPath(indexPath))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "detailedViewSegue"{
            var cell = sender as! PhotoCell
            var indexPath = tableView.indexPathForCell(cell)
            var detailsViewController = segue.destinationViewController as! DetailedViewController
            
            var photoUrl = photoUrls[indexPath!.row]
            detailsViewController.photoUrl = photoUrl
            detailsViewController.locationText = cell.locationLabel.text!
                        
            detailsViewController.modalPresentationStyle = UIModalPresentationStyle.Custom
            detailsViewController.transitioningDelegate = DetailedViewTransition()
        }
        else if segue.identifier == "takePhotoSegue"{
            var photoCaptureController = segue.destinationViewController as! PhotoCaptureViewController
            photoCaptureController.alpha = 0
        }
    }
    
    func onTimer(){
        var query = PFQuery(className: "Post")
        query.findObjectsInBackgroundWithBlock { (results: [AnyObject]?, error: NSError?) -> Void in
            self.posts = results as! [PFObject]
            self.tableView.reloadData()
        }
    }
}
