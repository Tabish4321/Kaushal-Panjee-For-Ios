//
//  CustomActivityIndicator.swift
//  Aadhaar Service
//
//  Created by Rohan Kumar on 06/08/26.
//

internal import UIKit

class CustomActivityIndicator {
    static let sharedInstance = CustomActivityIndicator()
    
    private var activityIndicator: UIActivityIndicatorView?
    private var overlayView: UIView?
    private var timer: Timer?

    private init() {}

    /// Show the activity indicator with an optional timeout
    func showIndicator(view: UIView, color: UIColor, timeout: TimeInterval = 60.0) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }

            // Ensure only one overlay is added
            if self.overlayView != nil {
                return
            }

            // Create an overlay view to disable user interaction
            self.overlayView = UIView(frame: view.bounds)
            self.overlayView?.backgroundColor = UIColor(white: 0, alpha: 0.5)

            // Initialize the activity indicator with specified color
            if #available(iOS 13.0, *) {
                self.activityIndicator = UIActivityIndicatorView(style: .large)
            } else {
                self.activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
            }
            self.activityIndicator?.color = color
            self.activityIndicator?.center = self.overlayView!.center
            self.activityIndicator?.hidesWhenStopped = true

            // Add the activity indicator to the overlay view
            self.overlayView?.addSubview(self.activityIndicator!)

            // Add the overlay view to the main view
            view.addSubview(self.overlayView!)

            // Start animating the activity indicator
            self.activityIndicator?.startAnimating()

            // Disable user interaction on the view
            view.isUserInteractionEnabled = false

            // Start the auto-hide timer
//            self.startAutoHideTimer(view: view, timeout: timeout)
        }
    }

    /// Hide the activity indicator manually or automatically
    func hideIndicator(view: UIView) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }

            // Stop animating the activity indicator
            self.activityIndicator?.stopAnimating()

            // Remove all subviews from overlayView before removing it
            self.overlayView?.subviews.forEach { $0.removeFromSuperview() }

            // Remove overlay view
            self.overlayView?.removeFromSuperview()
            self.overlayView = nil // Reset overlay reference

            // Re-enable user interaction
            view.isUserInteractionEnabled = true

            // Invalidate the timer
            self.timer?.invalidate()
            self.timer = nil
        }
    }

    /// Starts a timer to hide the indicator automatically after a timeout
    private func startAutoHideTimer(view: UIView, timeout: TimeInterval) {
        timer?.invalidate() // Ensure no existing timer is running

        timer = Timer.scheduledTimer(withTimeInterval: timeout, repeats: false) { [weak self] _ in
            self?.hideIndicator(view: view)
            print("⏳ Indicator hidden automatically after \(timeout) seconds")
        }
    }
}
