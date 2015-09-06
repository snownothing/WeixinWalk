//
//  PageContentViewController.swift
//  微信运动
//
//  Created by Eular on 9/6/15.
//  Copyright © 2015 Eular. All rights reserved.
//

import UIKit

class PageContentViewController: UIViewController {

    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var subHeadingLabel: UILabel!
    @IBOutlet weak var pageImage: UIImageView!
    @IBOutlet weak var StartBtn: UIButton!
    
    var index: Int = 0
    var heading: String = ""
    var subHeading: String = ""
    var img: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        headingLabel.text = heading
        subHeadingLabel.text = subHeading
        pageImage.image = UIImage(named: img)
        //pageControl.currentPage = index
        StartBtn.hidden = ( index == 2 ) ? false : true
        StartBtn.layer.borderColor = UIColor.whiteColor().CGColor
        StartBtn.layer.borderWidth = 1
        StartBtn.layer.cornerRadius = 5
    }
    
    @IBAction func close(sender: AnyObject) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setBool(true, forKey: "hasViewedWalkthrough")
        let healthManager = HealthManager()
        healthManager.authorizeHealthKit() {
            (success, error) in
            if success {
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
