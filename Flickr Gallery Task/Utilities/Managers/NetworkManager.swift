//
//  NetworkManager.swift
//  Flickr Gallery Task
//
//  Created by Eden Chen on 25/11/2021.
//

import UIKit

class NetworkManager {
	
	static let shared = NetworkManager()
	
	private let API_Key = "YOUR_API"
	private let photosUrl = "https://www.flickr.com/services/rest/?method=flickr.photos.getRecent&extras=url_sq&format=json&nojsoncallback=1&api_key="
	private let pageUrl = "&page="
	
	let cache = NSCache<NSString, UIImage>()

	func getPhotos(page: Int, completed: @escaping (Result<[PhotoModel], FGError>) -> Void) {
		guard let url = URL(string: photosUrl + APIManager.API_Key + pageUrl + "\(page)") else {
			completed(.failure(.invalidURL))
			return
		}
		
		print(url)
		
		let task = URLSession.shared.dataTask(with: url) { data, response, error in
			if let _ = error {
				completed(.failure(.unableToComplete))
				return
			}

			guard let response = response as? HTTPURLResponse, response.statusCode == 200  else {
				completed(.failure(.invalidResponse))
				return
			}
			
			guard let data = data else {
				completed(.failure(.invalidData))
				return
			}
			
			
			do {
				let decoder = JSONDecoder()
				decoder.keyDecodingStrategy = .convertFromSnakeCase
				let decoderResponse = try decoder.decode(PhotosArrayModel.self, from: data)
				completed(.success(decoderResponse.photos.photo))
			} catch {
				completed(.failure(.unableToComplete))
			}
		}
		task.resume()
	}

	
	func getPages(completed: @escaping (Result<Int, FGError>) -> Void ) {
		guard let url = URL(string: photosUrl + API_Key + pageUrl + "\(1)") else {
			completed(.failure(.invalidURL))
			return
		}
		
		let task = URLSession.shared.dataTask(with: url) { data, response, error in
			if let _ = error {
				completed(.failure(.unableToComplete))
				return
			}
			
			guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
				completed(.failure(.invalidResponse))
				return
			}
			
			guard let data = data else {
				completed(.failure(.invalidData))
				return
			}

			do {
				let decoder = JSONDecoder()
				decoder.keyDecodingStrategy = .convertFromSnakeCase
				let decodedData = try decoder.decode(PhotosArrayModel.self, from: data)
				completed(.success(decodedData.photos.pages))
				
			} catch {
				completed(.failure(.unableToComplete))
			}

		}
		task.resume()
		
	}
}
