//
//  HealthKitManager.swift
//  HealthKitDemo
//
//  Created by Sanket Vaghela on 02/04/25.
//

import HealthKit

class HealthKitManager {
    private let healthStore = HKHealthStore()
    
    // HealthKit types we want to read
    var allDataTypes: Set<HKQuantityType> {
        let types: [HKQuantityType] = [
            HKQuantityType.quantityType(forIdentifier: .stepCount),
            HKQuantityType.quantityType(forIdentifier: .heartRate),
            HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning),
            HKQuantityType.quantityType(forIdentifier: .bodyMass)
        ].compactMap { $0 } // Remove any nil values
        
        return Set(types) // Convert array to set
    }
    
    private var stepCountType: HKQuantityType? {
        return HKQuantityType.quantityType(forIdentifier: .stepCount)
    }
    
    private var heartRateType: HKQuantityType? {
        return HKQuantityType.quantityType(forIdentifier: .heartRate)
    }
    
    private var distanceType: HKQuantityType? {
        return HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)
    }
    
    private var weightType: HKQuantityType? {
        return HKQuantityType.quantityType(forIdentifier: .bodyMass)
    }
    
    func requestAuthorization(completion: @escaping (Bool, Error?) -> Void) {
          guard HKHealthStore.isHealthDataAvailable() else {
              completion(false, NSError(domain: "com.healthkit.example", code: 1, userInfo: [NSLocalizedDescriptionKey: "HealthKit not available"]))
              return
          }
          
          healthStore.requestAuthorization(toShare: nil, read: allDataTypes, completion: completion)
      }
    
    // Generic function to fetch latest sample
    func fetchLatestSample(for identifier: HKQuantityTypeIdentifier, completion: @escaping (HKQuantitySample?, Error?) -> Void) {
        guard let sampleType = HKQuantityType.quantityType(forIdentifier: identifier) else {
            completion(nil, NSError(domain: "com.healthkit.example", code: 2, userInfo: [NSLocalizedDescriptionKey: "\(identifier) not available"]))
            return
        }
        
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        let query = HKSampleQuery(sampleType: sampleType,
                                 predicate: nil,
                                 limit: 1,
                                 sortDescriptors: [sortDescriptor]) { (_, samples, error) in
            DispatchQueue.main.async {
                completion(samples?.first as? HKQuantitySample, error)
            }
        }
        
        healthStore.execute(query)
    }
    
    func fetchTodayStatistics(for identifier: HKQuantityTypeIdentifier, completion: @escaping (HKStatistics?, Error?) -> Void) {
        guard let quantityType = HKQuantityType.quantityType(forIdentifier: identifier) else {
            completion(nil, NSError(domain: "com.healthkit.example", code: 2, userInfo: [NSLocalizedDescriptionKey: "\(identifier) not available"]))
            return
        }
        
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: quantityType,
                                    quantitySamplePredicate: predicate,
                                    options: .cumulativeSum) { (_, result, error) in
            DispatchQueue.main.async {
                completion(result, error)
            }
        }
        
        healthStore.execute(query)
    }
    func checkAuthorizationStatus(completion: @escaping (Bool, Error?) -> Void) {
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(false, NSError(domain: "com.healthkit.example", code: 1, userInfo: [NSLocalizedDescriptionKey: "HealthKit not available"]))
            return
        }
        
        guard let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount) else {
            completion(false, NSError(domain: "com.healthkit.example", code: 2, userInfo: [NSLocalizedDescriptionKey: "Step count not available"]))
            return
        }
        
        healthStore.getRequestStatusForAuthorization(toShare: [], read: allDataTypes) { status, error in
            completion(status == .unnecessary, error)
        }
    }
}
