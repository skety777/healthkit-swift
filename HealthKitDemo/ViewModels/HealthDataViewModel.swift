//
//  HealthDataViewModel.swift
//  HealthKitDemo
//
//  Created by Sanket Vaghela on 02/04/25.
//

import Foundation
import Combine
import HealthKit


class HealthDataViewModel: ObservableObject {
    private let healthKitManager = HealthKitManager()
    
    @Published var stepCount: Double = 0
    @Published var heartRate: Double = 0
    @Published var distance: Double = 0
    @Published var weight: Double = 0
    @Published var isLoading = false
    @Published var authorizationGranted = false

    func checkAuthorizationStatus() {
        isLoading = true
        healthKitManager.checkAuthorizationStatus { [weak self] granted, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                self?.authorizationGranted = granted
                if granted {
                    self?.fetchAllHealthData()
                } else if let error = error {
                    print("Authorization check error: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func requestAuthorization() {
        isLoading = true
        healthKitManager.requestAuthorization { [weak self] success, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                self?.authorizationGranted = success
                if success {
                    self?.fetchAllHealthData()
                } else if let error = error {
                    print("Authorization error: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func fetchAllHealthData() {
        fetchStepCount()
        fetchHeartRate()
        fetchDistance()
        fetchWeight()
    }
    
    private func fetchStepCount() {
        healthKitManager.fetchTodayStatistics(for: .stepCount) { [weak self] statistics, error in
            DispatchQueue.main.async {
                if let sum = statistics?.sumQuantity() {
                    let steps = sum.doubleValue(for: HKUnit.count())
                    self?.stepCount = steps
                } else {
                    self?.stepCount = 0
                    if let error = error {
                        print("Step count error: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    private func fetchHeartRate() {
        healthKitManager.fetchLatestSample(for: .heartRate) { [weak self] sample, error in
            DispatchQueue.main.async {
                if let heartRate = sample?.quantity.doubleValue(for: HKUnit(from: "count/min")) {
                    self?.heartRate = heartRate
                } else {
                    self?.heartRate = 0
                    if let error = error {
                        print("Heart rate error: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    private func fetchDistance() {
        healthKitManager.fetchTodayStatistics(for: .distanceWalkingRunning) { [weak self] statistics, error in
            DispatchQueue.main.async {
                if let sum = statistics?.sumQuantity() {
                    let meters = sum.doubleValue(for: HKUnit.meter())
                    self?.distance = meters / 1000 // Convert to km
                } else {
                    self?.distance = 0
                    if let error = error {
                        print("Distance error: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    private func fetchWeight() {
        healthKitManager.fetchLatestSample(for: .bodyMass) { [weak self] sample, error in
            DispatchQueue.main.async {
                if let weight = sample?.quantity.doubleValue(for: HKUnit.gramUnit(with: .kilo)) {
                    self?.weight = weight
                } else {
                    self?.weight = 0
                    if let error = error {
                        print("Weight error: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
}
