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
    
    var outputImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // To be updated
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
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("PhotoCell") as! PhotoCell
        var photo = photos[indexPath.row] as! NSDictionary
        
        var photoUrl = photo.valueForKeyPath("images.low_resolution.url") as? String
        
        photoUrls.append(photoUrl!)

        cell.photoView.setImageWithURL(NSURL(string: photoUrl!))
        
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
        var cell = sender as! PhotoCell
        var indexPath = tableView.indexPathForCell(cell)
        var detailsViewController = segue.destinationViewController as! DetailedViewController
        
        //refactor
        //var photo = photos[indexPath!.row] as! NSDictionary
        //var photoUrl = photo.valueForKeyPath("images.standard_resolution.url") as? String
        
        var photoUrl = photoUrls[indexPath!.row]
        detailsViewController.photoUrl = photoUrl
        detailsViewController.locationText = cell.locationLabel.text!
        
        //detailsViewController.photoView.setImageWithURL(NSURL(string: photoUrl))
        
        //detailsViewController.photoView.image = cell.photoView.image
        
        detailsViewController.modalPresentationStyle = UIModalPresentationStyle.Custom
        detailsViewController.transitioningDelegate = DetailedViewTransition()
    }
}
