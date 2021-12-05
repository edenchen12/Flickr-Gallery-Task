//
//  FGError.swift
//  Flickr Gallery Task
//
//  Created by Eden Chen on 25/11/2021.
//

import Foundation

enum FGError: String, Error {
	case invalidURL = "Something went wrong with your request. Please try again."
	case invalidResponse = "Invalid response from the server. Please try again."
	case invalidData = "The data received from the server was invalid. Please try again."
	case unableToComplete = "Unable to complete your request. Please check your internet connection."
}
