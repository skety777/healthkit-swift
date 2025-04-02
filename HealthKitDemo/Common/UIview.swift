//
//  UIview.swift
//  HealthKitDemo
//
//  Created by Sanket Vaghela on 02/04/25.
//

import UIKit

extension UIView {
    func animateCount(from startValue: Double, to endValue: Double, duration: TimeInterval, decimalPlaces: Int = 0, unit: String = "") {
        guard let label = self as? UILabel else { return }
        
        let steps = min(abs(endValue - startValue), 1000) // Limit steps for performance
        let stepDuration = duration / TimeInterval(steps)
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = decimalPlaces
        numberFormatter.minimumFractionDigits = decimalPlaces
        
        var currentValue = startValue
        
        Timer.scheduledTimer(withTimeInterval: stepDuration, repeats: true) { timer in
            currentValue += (endValue - startValue) / Double(steps)
            
            if (startValue < endValue && currentValue >= endValue) ||
               (startValue > endValue && currentValue <= endValue) {
                currentValue = endValue
                timer.invalidate()
            }
            
            DispatchQueue.main.async {
                if let formattedString = numberFormatter.string(from: NSNumber(value: currentValue)) {
                    label.text = "\(formattedString)\(unit)"
                }
            }
        }
    }
}
