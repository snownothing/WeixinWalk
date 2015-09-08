//
//  PageViewController.swift
//  微信运动
//
//  Created by Eular on 9/6/15.
//  Copyright © 2015 Eular. All rights reserved.
//

import UIKit
import AVFoundation

class PageViewController: UIPageViewController, UIPageViewControllerDataSource {
    
    var avPlayer: AVAudioPlayer!
    var pageHeadings = ["看着他们的背影", "也想荣登榜首", "直到此刻"]
    var subHeadings = ["心情跌至谷底", "一直日光倾城", "不为繁华而动，只为王者归来"]
    var pageImages = ["1", "2", "3"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        dataSource = self
        if let startingViewController = self.viewControllerAtIndex(0) {
            setViewControllers([startingViewController], direction: .Forward, animated: true, completion: nil)
        }
        
        do {
            avPlayer = try AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("Breath and Life", ofType: "mp3")!))
            avPlayer.play()
        } catch {
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        avPlayer.stop()
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        var index = ( viewController as! PageContentViewController ).index
        index++
        return viewControllerAtIndex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        var index = ( viewController as! PageContentViewController ).index
        index--
        return viewControllerAtIndex(index)
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        if let pageView = storyboard?.instantiateViewControllerWithIdentifier("PageContentViewController") as? PageContentViewController {
            return pageView.index
        }
        return 0
    }
    
    func viewControllerAtIndex(index: Int) -> PageContentViewController? {
        
        if index == NSNotFound || index < 0 || index >= self.pageHeadings.count {
            return nil
        }
        
        // Create a new view controller and pass suitable data.
        if let pageView = storyboard?.instantiateViewControllerWithIdentifier("PageContentViewController") as? PageContentViewController {
            
            pageView.heading = pageHeadings[index]
            pageView.subHeading = subHeadings[index]
            pageView.img = pageImages[index]
            pageView.index = index
            
            return pageView
        }
        
        return nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
