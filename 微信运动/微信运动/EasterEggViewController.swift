//
//  EasterEggViewController.swift
//  微信运动
//
//  Created by Eular on 9/6/15.
//  Copyright © 2015 Eular. All rights reserved.
//

import UIKit

class EasterEggViewController: UIViewController {

    @IBOutlet weak var stepTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "彩蛋"
    }

    @IBAction func gowalk(sender: AnyObject) {
        let healthManager = HealthManager()
        if !stepTF.text!.isEmpty {
            let steps = Double(stepTF.text!)
            healthManager.saveStepsSample(steps!, endDate: NSDate(), duration: 30) {
                (success, error) in
                dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                    self.stepTF.text = ""
                    self.stepTF.resignFirstResponder()
                    self.view.makeToast(message: "跑步成功！", duration: 1.5, position: "center")
                })
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        stepTF.resignFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
