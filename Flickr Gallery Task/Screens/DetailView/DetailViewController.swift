//
//  DetailViewController.swift
//  Flickr Gallery Task
//
//  Created by Eden Chen on 05/12/2021.
//

import UIKit

class DetailViewController: UIViewController {

	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var xButton: UIButton!
	
	let viewModel = DetailViewModel()
	var selectedPhoto: PhotoModel?
	
	
	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view.
		xButtonUI()
		
		guard let safeSelectedPhoto = selectedPhoto else {return}
		viewModel.downloadImage(view: view, imageView: imageView, from: safeSelectedPhoto)

	}
	
	
	@IBAction func xButtonTapped(_ sender: UIButton) {
		dismiss(animated: true, completion: nil)
	}
	
	
	func xButtonUI() {
		if self.traitCollection.userInterfaceStyle == .dark {
			xButton.tintColor = .white
		} else {
			xButton.tintColor = .black
		}
	}

}
