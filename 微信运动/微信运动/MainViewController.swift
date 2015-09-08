//
//  ViewController.swift
//  微信运动
//
//  Created by Eular on 9/5/15.
//  Copyright © 2015 Eular. All rights reserved.
//

import UIKit

class MainViewController: UITableViewController {
    
    @IBOutlet weak var stepsLabel: UILabel!
    
    @IBOutlet var longPressGesture: UILongPressGestureRecognizer!
    
    
    let healthManager = HealthManager()
    var scene = WXSceneSession.rawValue
    var egg_count = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // 引导页
        let defaults = NSUserDefaults.standardUserDefaults()
        let hasViewedWalkthrough = defaults.boolForKey("hasViewedWalkthrough")
        if !hasViewedWalkthrough {
            if let pageViewController = storyboard?.instantiateViewControllerWithIdentifier("PageViewController") as? PageViewController {
                self.presentViewController(pageViewController, animated: true, completion: nil)
            }
        }
        
        let headerView = UIView()
        let app_icon = UIImageView()
        let app_name = UILabel()
        let app_words = UILabel()
        let width = self.view.bounds.size.width
        let height = CGFloat(250)
        let icon_offset = CGFloat(40)
        let app_icon_width = CGFloat(80)
        headerView.frame = CGRectMake(0, 0, width, height)
        app_icon.frame = CGRectMake((width - app_icon_width) / 2, icon_offset, app_icon_width, app_icon_width)
        app_icon.image = UIImage(named: "health_icon")
        headerView.addSubview(app_icon)
        app_name.text = "健康"
        app_name.frame = CGRectMake(0, icon_offset + app_icon_width + 10, width, 20)
        app_name.textAlignment = .Center
        app_name.textColor = UIColor.grayColor()
        app_name.font = UIFont(name: app_words.font.fontName, size: 22)
        headerView.addSubview(app_name)
        app_words.text = "\"微信运动\"读取的是系统的健康数据，且最高步数为98800步"
        app_words.frame = CGRectMake(20, height - 70, width - 40, 40)
        app_words.numberOfLines = 2
        app_words.textColor = UIColor.grayColor()
        app_words.font = UIFont(name: app_words.font.fontName, size: 15)
        headerView.addSubview(app_words)
        tableView.tableHeaderView = headerView
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"weixinShareDone:", name: shareDoneNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"weixinShareCancel:", name: shareCancelNotification, object: nil)
        
        updateSteps()
    }
    
    func updateSteps() {
        healthManager.readTotalSteps {
            (steps) in
            dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                self.stepsLabel.text = "\(steps)"
            })
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        egg_count = 0
        updateSteps()
    }
    
    func weixinShareDone(notification: NSNotification) {
        let stepcount = (scene == WXSceneTimeline.rawValue) ? 10000.0 : 5000.0
        healthManager.saveStepsSample(stepcount, endDate: NSDate(), duration: 30) {
            (success, error) in
            dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                self.view.makeToast(message: "哇咔咔，为你增加\(stepcount)步!", duration: 2, position: "center")
                self.updateSteps()
            })
        }
    }
    
    func weixinShareCancel(notification: NSNotification) {
        self.view.makeToast(message: "分享作弊被我发现啦！", duration: 2, position: "center")
    }
    
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)

        var share = false
        switch indexPath.row {
            case 0:
                egg_count++
            case 1:
                share = true
                scene = WXSceneTimeline.rawValue
            case 2:
                share = true
                scene = WXSceneSession.rawValue
            default:
                break
        }
        
        if share {
            let message =  WXMediaMessage()
            
            message.title = "我在微信运动上走了98800，不服来战！"
            message.description = "有了它，妈妈再也不用担心我会为了刷榜而运动啦"
            message.setThumbImage(UIImage(named: "App"))
            
            let ext =  WXWebpageObject()
            ext.webpageUrl = AppDownload
            message.mediaObject = ext
            
            let req =  SendMessageToWXReq()
            req.bText = false
            req.message = message
            req.scene = Int32(scene)
            WXApi.sendReq(req)
        } else {
            self.view.makeToast(message: "哈哈，想装逼被我发现啦", duration: 2, position: "center")
        }
    }
    
    @IBAction func handleLongPressGesture(sender: UILongPressGestureRecognizer) {
        if (sender.state == .Ended) {
            self.performSegueWithIdentifier("easterEggSegue", sender: nil)
        }
    }
    


}

