//
//  FlickrGalleryViewModel.swift
//  Flickr Gallery Task
//
//  Created by Eden Chen on 05/12/2021.
//

import UIKit

class FlickrGalleryViewModel {

	var page = 1
	var pages = 0
	
	var photos: [PhotoModel] = []
	var image = UIImage()
	let cache = NetworkManager.shared.cache


	
	var isLoading = false
	let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)

	func startLoading(view: UIView)  {
		
			isLoading = true
			activityIndicator.hidesWhenStopped = true
			activityIndicator.center = view.center
			if view.traitCollection.userInterfaceStyle == .dark {
				activityIndicator.color = .white
			} else {
				activityIndicator.color = .gray
			}
			
			activityIndicator.startAnimating()
		view.addSubview(activityIndicator)
		
	}
	
	func stopLoading() {
		
		self.isLoading = false
		self.activityIndicator.stopAnimating()

	}
	
	
	func downloadImage(collectionView: UICollectionView,from urlString: String, indexPath: IndexPath) {
		
		let cacheKey = NSString(string: urlString)
		
		if let image = cache.object(forKey: cacheKey) {
			self.image = image
			return
		}
		
		
		
		guard let url = URL(string: urlString) else { return }
		
		let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
			
			guard let self = self else {return}
			if error != nil {return}
			
			guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { return	}
			
			guard let data = data else { return }
			
			guard let image = UIImage(data: data) else { return }
			self.cache.setObject(image, forKey: cacheKey)
			DispatchQueue.main.async {
				self.image = image
				collectionView.reloadItems(at: [indexPath])
			}
			
		}
		
		task.resume()
		
	}
	
	
	func getPhotos(view: UIView, page: Int, collectionView: UICollectionView?) {
		
		startLoading(view: view)
		NetworkManager.shared.getPhotos(page: page) { result in
			DispatchQueue.main.async {
				switch result {
					case .success(let photosArray):
						self.photos += photosArray
					case .failure(let error):
						switch error {
								
							case .invalidURL:
								print(error.rawValue)
							case .invalidResponse:
								print(error.rawValue)
							case .invalidData:
								print(error.rawValue)
							case .unableToComplete:
								print(error.rawValue)
						}
				}
				
				self.stopLoading()
				collectionView?.reloadData()
			}
			
		}
		
	}

	
	func getPages() {
		NetworkManager.shared.getPages { result in
			DispatchQueue.main.async {
				switch result {
					case .success(let pages):
						self.pages = pages
					case .failure(let error):
						switch error {
							case .invalidURL:
								print(error.rawValue)
							case .invalidResponse:
								print(error.rawValue)
							case .invalidData:
								print(error.rawValue)
							case .unableToComplete:
								print(error.rawValue)
						}
				}
			}
		}
	}
}
