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
    var posts:[PFObject] = []
    var selectedCell: PhotoCell!
    var transition: DetailedViewTransition!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        var timer = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: "onTimer", userInfo: nil, repeats: true)
        timer.fire()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("PhotoCell") as! PhotoCell
        
        var post = posts[indexPath.row] as PFObject
        var photoUrl: String = post["imageFile"]!.url!!
        cell.photoView.image = nil
        cell.photoView.setImageWithURL(NSURL(string: photoUrl))
        
        return cell
    }
        
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
            selectedCell = cell
            
            var detailedViewController = segue.destinationViewController as! DetailedViewController
            
            var post = posts[indexPath!.row]
            detailedViewController.post = post
            
            detailedViewController.photoUrl = post["imageFile"]!.url
            
            let likes = post["likes"] as? Int
            detailedViewController.likes = likes
            
            detailedViewController.modalPresentationStyle = UIModalPresentationStyle.Custom
            transition = DetailedViewTransition()
            transition.feedViewController = self
            transition.detailedViewController = detailedViewController
            detailedViewController.transitioningDelegate = transition
            
        }
        else if segue.identifier == "takePhotoSegue"{
            var photoCaptureController = segue.destinationViewController as! PhotoCaptureViewController
            photoCaptureController.alpha = 0
        }
    }
    
    func onTimer(){
        var query = PFQuery(className: "Post")
        query.addDescendingOrder("createdAt")
        query.findObjectsInBackgroundWithBlock { (results: [AnyObject]?, error: NSError?) -> Void in
            self.posts = results as! [PFObject]
            self.tableView.reloadData()
        }
    }
}
