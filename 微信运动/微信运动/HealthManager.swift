//
//  HealthManager.swift
//  微信运动
//
//  Created by Eular on 9/5/15.
//  Copyright © 2015 Eular. All rights reserved.
//

import UIKit
import HealthKit

extension Int {
    var day: NSTimeInterval {
        let DAY_IN_SECONDS = 60 * 60 * 24
        let day:Double = Double(DAY_IN_SECONDS) * Double(self)
        return day
    }
}

class HealthManager: NSObject {
    
    let healthKitStore = HKHealthStore()
    
    func authorizeHealthKit(completion: ((success: Bool, error: NSError?) -> Void)!) {
        let healthKitTypesToWrite: Set = [
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierStepCount)!,
        ]
        
        let healthKitTypesToRead: Set = [
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierStepCount)!,
        ]
        
        if !HKHealthStore.isHealthDataAvailable() {
            let error = NSError(domain: "com.eular.weixinwalk", code: 2, userInfo: [NSLocalizedDescriptionKey:"HealthKit is not available in this Device"])
            if completion != nil {
                completion(success: false, error: error)
            }
            return
        }
        
        healthKitStore.requestAuthorizationToShareTypes(healthKitTypesToWrite, readTypes: healthKitTypesToRead) { (success, error) -> Void in
            if completion != nil {
                completion(success: success, error: error)
            }
        }
    }
    
    func saveStepsSample(steps: Double, endDate: NSDate, duration: Int, completion: ( (Bool, NSError!) -> Void)!) {
        let sampleType = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierStepCount)
        let stepsQuantity = HKQuantity(unit: HKUnit.countUnit(), doubleValue: steps)
        let startDate = endDate.dateByAddingTimeInterval(0 - 60 * Double(duration))
        let stepsSample = HKQuantitySample(type: sampleType!, quantity: stepsQuantity, startDate: startDate, endDate: endDate)
        
        self.healthKitStore.saveObject(stepsSample, withCompletion: { (success, error) -> Void in
            completion(success, error)
        })
    }
    
    func readStepsWorksout(limit: Int, completion: (([AnyObject]!, NSError!) -> Void)!) {
        let sampleType = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierStepCount)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let predicate = HKQuery.predicateForObjectsFromSource(HKSource.defaultSource())
        let sampleQuery = HKSampleQuery(sampleType: sampleType!, predicate: predicate, limit: limit, sortDescriptors: [sortDescriptor])
            { (sampleQuery, results, error ) -> Void in
                if let queryError = error {
                    print( "There was an error while reading the samples: \(queryError.localizedDescription)")
                }
                completion(results, error)
        }
        healthKitStore.executeQuery(sampleQuery)
    }
    
    func readTotalSteps(completion: ((Int) -> Void)) {
        let endDate = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let startDate = formatter.dateFromString(formatter.stringFromDate(endDate))
        let sampleType = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierStepCount)
        let predicate = HKQuery.predicateForSamplesWithStartDate(startDate, endDate: endDate, options: .None)
        
        let sampleQuery = HKSampleQuery(sampleType: sampleType!, predicate: predicate, limit: 0, sortDescriptors: nil, resultsHandler: {
            (sampleQuery, results, error ) -> Void in
            if let queryError = error {
                print( "There was an error while reading the samples: \(queryError.localizedDescription)")
            }
            
            var steps: Double = 0
            if results?.count > 0 {
                for result in results as! [HKQuantitySample] {
                    steps += result.quantity.doubleValueForUnit(HKUnit.countUnit())
                }
            }
            completion(Int(steps))
        })
        
        healthKitStore.executeQuery(sampleQuery)
    }
    
    func removeSample(sample: HKQuantitySample, completion: ( (Bool, NSError!) -> Void)!) {
        self.healthKitStore.deleteObject(sample, withCompletion: { (results, error) -> Void in
            completion(results, error)
        })
    }
}
