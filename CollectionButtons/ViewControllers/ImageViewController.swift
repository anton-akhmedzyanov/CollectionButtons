//
//  ImageViewController.swift
//  CollectionButtons
//
//  Created by Anton Akhmedzyanov on 06.05.2023.
//

import UIKit

final class ImageViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private let networkManager = NetWorkManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        fetchImage()
    }
    
    private func fetchImage() {
        networkManager.fetchImage(from: Link.imageURL.url) { [weak self] result in
            switch result {
            case .success(let imageData):
                self?.imageView.image = UIImage(data: imageData)
                self?.activityIndicator.stopAnimating()
            case .failure(let failure):
                print(failure)
            }
        }
    }
}

