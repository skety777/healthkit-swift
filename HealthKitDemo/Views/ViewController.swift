//
//  ViewController.swift
//  HealthKitDemo
//
//  Created by Sanket Vaghela on 02/04/25.
//

import UIKit
import HealthKit
import Combine

class ViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var stepCountLabel: UILabel!
    @IBOutlet weak var heartRateLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var authorizeButton: UIButton!
    @IBOutlet  var backgroundViews: [UIView]!
    
    // MARK: - Properties
    private let viewModel = HealthDataViewModel()
    private var cancellables = Set<AnyCancellable>()
    private let animationDuration = 1.5

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        checkAuthorizationStatus()
    }
    
    // MARK: - IBActions
    @IBAction func authorizeButtonTapped(_ sender: UIButton) {
        activityIndicator.startAnimating()
        viewModel.requestAuthorization()
    }
    
    // MARK: - Private Methods
    private func setupBindings() {
        viewModel.$stepCount
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                self?.stepCountLabel.animateCount(from: 0, to: value, duration: self?.animationDuration ?? 0.1, decimalPlaces: 0, unit: "")
            }
            .store(in: &cancellables)
        
        viewModel.$heartRate
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                self?.heartRateLabel.animateCount(from: 0, to: value, duration: self?.animationDuration ?? 0.1, decimalPlaces: 0, unit: "")
            }
            .store(in: &cancellables)
        
        viewModel.$distance
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                self?.distanceLabel.animateCount(from: 0, to: value, duration: self?.animationDuration ?? 1.0, decimalPlaces: 2, unit: "")
            }
            .store(in: &cancellables)
        
        viewModel.$weight
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                self?.weightLabel.animateCount(from: 0, to: value, duration: self?.animationDuration ?? 0.1, decimalPlaces: 1, unit: "")
            }
            .store(in: &cancellables)

        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                isLoading ? self?.activityIndicator.startAnimating() : self?.activityIndicator.stopAnimating()
                self?.authorizeButton.isEnabled = !isLoading
            }
            .store(in: &cancellables)
        
        viewModel.$authorizationGranted
            .receive(on: DispatchQueue.main)
            .sink { [weak self] granted in
                self?.authorizeButton.setTitle(granted ? "Refresh Data" : "Authorize HealthKit", for: .normal)
                if granted {
                    self?.viewModel.fetchAllHealthData()
                }
            }
            .store(in: &cancellables)
    }
    
    private func checkAuthorizationStatus() {
        activityIndicator.startAnimating()
        viewModel.checkAuthorizationStatus()
    }
    
    private func showAuthorizationAlert() {
        let alert = UIAlertController(
            title: "HealthKit Access Required",
            message: "Please enable HealthKit access in Settings to view your health data.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Open Settings", style: .default) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
        })
        
        present(alert, animated: true)
    }
}
extension ViewController{
    func setupUI(){
        for backView in backgroundViews {
            backView.layer.borderColor = UIColor.white.cgColor
            backView.layer.borderWidth = 1
            backView.layer.cornerRadius = 15
        }
    }
}

