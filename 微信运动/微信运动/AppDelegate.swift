//
//  AppDelegate.swift
//  微信运动
//
//  Created by Eular on 9/5/15.
//  Copyright © 2015 Eular. All rights reserved.
//

import UIKit

let LouzaiWXCode = "wx591c0178c80b80e7"
let AppDownload = "http://pre.im/cctv"
let FollowMyWeChat = "http://weixin.qq.com/r/mkyguMHEb5wQrYXb9xmI"
let shareCancelNotification = "ShareCancelNotification"
let shareDoneNotification = "ShareDoneNotification"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, WXApiDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        UINavigationBar.appearance().barTintColor = UIColor.blackColor()
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UINavigationBar.appearance().barStyle = UIBarStyle.Black
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        WXApi.registerApp(LouzaiWXCode)
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
        return WXApi.handleOpenURL(url, delegate: self)
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return WXApi.handleOpenURL(url, delegate: self)
    }
    
    func onResp(resp: BaseResp!) {
        /*
        ErrCode  ERR_OK = 0(用户同意)
        ERR_AUTH_DENIED = -4（用户拒绝授权）
        ERR_USER_CANCEL = -2（用户取消）
        */
        
        if resp.isKindOfClass(SendMessageToWXResp) {
            var noti = ""
            if resp.errCode == 0 {
                noti = shareDoneNotification
            } else if resp.errCode == -2 {
                noti = shareCancelNotification
            }
            NSNotificationCenter.defaultCenter().postNotificationName(noti, object: nil)
        }
    }

}

