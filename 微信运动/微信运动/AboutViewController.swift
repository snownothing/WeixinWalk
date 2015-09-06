//
//  AboutViewController.swift
//  微信运动
//
//  Created by Eular on 9/6/15.
//  Copyright © 2015 Eular. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {


    @IBOutlet weak var QRImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "关于"
        QRImageView.image = QRCode().make(FollowMyWeChat)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
