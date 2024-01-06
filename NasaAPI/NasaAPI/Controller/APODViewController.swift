//
//  ViewController.swift
//  NasaAPI
//
//  Created by Fernando Gutiérrez on 04/01/24.
//

import UIKit

class APODViewController: UIViewController {
    
    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var imageTitleLabel: UILabel!
    @IBOutlet weak var imageDescriptionTextView: UITextView!
    @IBOutlet weak var imageDateLabel: UILabel!
    @IBOutlet weak var imageCopyrightLabel: UILabel!
    
    var apiManager = APIManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        apiManager.delegate = self
        apiManager.fetchAPOD()
    }
}

extension APODViewController: APIManagerDelegate {
    func didFailWithError(error: Error) {
        print(error)
    }
    
    func didUpdateAPODData(_ apiManager: APIManager, apod: APODData) {
        DispatchQueue.main.async {
            self.imageTitleLabel.text = apod.title
            self.imageDescriptionTextView.text = apod.explanation
            self.imageDateLabel.text = "Date of capture: " + apod.date
            self.imageCopyrightLabel.text = "Copyright: " + apod.copyright
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

