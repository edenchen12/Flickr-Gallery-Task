//
//  DetailViewModelController.swift
//  Flickr Gallery Task
//
//  Created by Eden Chen on 05/12/2021.
//

import Foundation
import UIKit

class DetailViewModel {
	
	let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)

	
	func downloadImage(view: UIView, imageView: UIImageView, from photo: PhotoModel) {
		startLoading(view: view)
		let stringUrl =  "https://live.staticflickr.com/\(photo.server)/\(photo.id)_\(photo.secret)_n.jpg"
		guard let url = URL(string: stringUrl) else { return }
	
		let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
			 
			guard let self = self else {return}
			if error != nil {return}
			
			guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { return	}
			
			guard let data = data else { return }
			
			guard let image = UIImage(data: data) else { return }
			
			DispatchQueue.main.async {
				imageView.image = image
				self.stopLoading()
			}

		}
		task.resume()
	}
	
	
	func startLoading(view: UIView) {
		activityIndicator.hidesWhenStopped = true
		activityIndicator.center = view.center
		activityIndicator.color = .gray
		activityIndicator.startAnimating()
		view.addSubview(activityIndicator)
	}

	
	func stopLoading() {
		activityIndicator.stopAnimating()
	}
	
}
