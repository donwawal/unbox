//
//  TutorialViewController.swift
//  unbox
//
//  Created by Jules Walter on 6/14/15.
//  Copyright (c) 2015 Jules Walter. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var tutorialScrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        tutorialScrollView.contentSize.width = 1280
        tutorialScrollView.delegate = self
        self.view.backgroundColor = UIColor(red:0.094,  green:0.557,  blue:0.882, alpha:1)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {// called when scroll view grinds to a halt
        var page : Int = Int(round(tutorialScrollView.contentOffset.x / 320))
        pageControl.currentPage = page
        
        if page == 3 {
            pageControl.alpha = 0
            let user = PFUser.currentUser()!
            user["doneTutorial"] = 1
            user.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
                println("tutorial done")
            })
            
        } else {
            pageControl.alpha = 1
        }
    }
}
