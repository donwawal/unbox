//
//  DetailedViewTransition.swift
//  unbox
//
//  Created by Jules Walter on 6/13/15.
//  Copyright (c) 2015 Jules Walter. All rights reserved.
//

import UIKit

class DetailedViewTransition: BaseTransition {
    var feedViewController: FeedViewController!
    var detailedViewController: DetailedViewController!
    
    var originFrame: CGRect!
    var destinationFrame: CGRect!
    var window = UIApplication.sharedApplication().keyWindow
    
    override func presentTransition(containerView: UIView, fromViewController: UIViewController, toViewController: UIViewController) {
        
        originFrame = window?.convertRect(feedViewController.selectedCell.photoView.frame, fromView: feedViewController.selectedCell.cellContainerView)
        destinationFrame = window?.convertRect(detailedViewController.photoView.frame, fromView: containerView)
        
        var transitionImageView = UIImageView()
        transitionImageView.image = feedViewController.selectedCell.photoView.image
        transitionImageView.frame = originFrame
        transitionImageView.contentMode = feedViewController.selectedCell.photoView.contentMode
        transitionImageView.clipsToBounds = true
        window?.addSubview(transitionImageView)
        
        toViewController.view.alpha = 0
        
        UIView.animateWithDuration(2, animations: { () -> Void in
            transitionImageView.frame.size = self.destinationFrame.size
            transitionImageView.frame.origin = self.destinationFrame.origin
            }) { (Bool) -> Void in
                toViewController.view.alpha = 1
                transitionImageView.removeFromSuperview()
                self.finish()
        }
    }
    
    override func dismissTransition(containerView: UIView, fromViewController: UIViewController, toViewController: UIViewController) {
        
        var transitionImageView = UIImageView()
        transitionImageView.image = detailedViewController.photoView.image
        transitionImageView.frame = destinationFrame
        transitionImageView.contentMode = detailedViewController.photoView.contentMode
        transitionImageView.clipsToBounds = true
        window?.addSubview(transitionImageView)
        
        UIView.animateWithDuration(2, animations: { () -> Void in
            fromViewController.view.alpha = 0
            
            transitionImageView.frame.size = self.originFrame.size
            transitionImageView.frame.origin = self.originFrame.origin
            
            }) { (Bool) -> Void in

                transitionImageView.removeFromSuperview()
                self.finish()
        }
    }
    
}
