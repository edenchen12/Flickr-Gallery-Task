//
//  PhotosModel.swift
//  Flickr Gallery Task
//
//  Created by Eden Chen on 25/11/2021.
//

import Foundation

struct PhotosArrayModel: Decodable {
	let photos: PhotosModel
}

struct PhotosModel: Decodable {
	let page: Int
	let pages: Int
	let photo: [PhotoModel]
}

struct PhotoModel: Decodable {
	let id: String
	let secret: String
	let server: String
	let urlSq: String
}


