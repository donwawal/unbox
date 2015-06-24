//
//  TutorialViewController.swift
//  unbox
//
//  Created by Jules Walter on 6/14/15.
//  Copyright (c) 2015 Jules Walter. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController{
    
    override func viewDidLoad() {

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didPressGetStarted(sender: UIButton) {
        super.viewDidLoad()
        let user = PFUser.currentUser()!
        user["doneTutorial"] = 1
        user.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in

        })
    }
    
}
