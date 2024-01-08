//
//  ViewController.swift
//  NasaAPI
//
//  Created by Fernando Gutiérrez on 04/01/24.
//

import UIKit
import SkeletonView

class APODViewController: UIViewController {
    
    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var imageTitleLabel: UILabel!
    @IBOutlet weak var imageDescriptionTextView: UITextView!
    @IBOutlet weak var imageDateLabel: UILabel!
    @IBOutlet weak var imageCopyrightLabel: UILabel!
    
    var apiManager = APIManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Skeleton Package Setup
        setupSkeleton()
        // API Delegate
        apiManager.delegate = self
        // Fetch Data from API
        apiManager.fetchAPOD()
    }
    
    // Set the elements for animation
    private func setupSkeleton() {
        // Set the animation ON
        pictureImageView.isSkeletonable = true
        imageTitleLabel.isSkeletonable = true
        imageDescriptionTextView.isSkeletonable = true
        imageDateLabel.isSkeletonable = true
        imageCopyrightLabel.isSkeletonable = true
        
        // Select the animation for each Element
        pictureImageView.showAnimatedGradientSkeleton()
        imageTitleLabel.showAnimatedGradientSkeleton()
        imageDescriptionTextView.showAnimatedGradientSkeleton()
        imageDateLabel.showAnimatedGradientSkeleton()
        imageCopyrightLabel.showAnimatedGradientSkeleton()
    }
}

extension APODViewController: APIManagerDelegate {
    func didFailWithError(error: Error) {
        print(error)
    }
    
    func didUpdateAPODData(_ apiManager: APIManager, apod: APODData) {
        DispatchQueue.main.async {
            // Stop the animation
            self.pictureImageView.hideSkeleton()
            self.imageDescriptionTextView.hideSkeleton()
            self.imageTitleLabel.hideSkeleton()
            self.imageDateLabel.hideSkeleton()
            self.imageCopyrightLabel.hideSkeleton()
            
            self.imageTitleLabel.text = apod.title
            self.imageDescriptionTextView.text = apod.explanation
            self.imageDateLabel.text = "Date of capture: " + apod.date
            self.imageCopyrightLabel.text = "Copyright: " + (apod.copyright ?? "NASA API")
            if let imageURL = URL(string: apod.hdurl) {
                DispatchQueue.global().async {
                    guard let imageData = try? Data(contentsOf: imageURL) else { return }
                    let image = UIImage(data: imageData)
                    DispatchQueue.main.async {
                        self.pictureImageView.image = image
                    }
                }
            }
        }
    }
}

