//
//  FlickrGalleryCVC.swift
//  Flickr Gallery Task
//
//  Created by Eden Chen on 23/11/2021.
//

import UIKit

class FlickrGalleryCVC: UICollectionViewController{
	
	private let reuseIdentifier = "cell"
	private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
	private let itemsPerRow: CGFloat = 4
	
	let viewModel = FlickrGalleryViewModel()
	var selectedPhotoId: PhotoModel?
	var page = 0
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		navigationItem.title = "Flickr Gallery"
		
		collectionView.delegate = self
		collectionView.dataSource = self
		
		viewModel.getPages()
		page = viewModel.page
		
		viewModel.getPhotos(view: view, page: page, collectionView: collectionView)
		

		
	}
	
			
	// MARK: UICollectionViewDataSource
	
	override func numberOfSections(in collectionView: UICollectionView) -> Int {
		// #warning Incomplete implementation, return the number of sections
		return 1
	}
	
	
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		// #warning Incomplete implementation, return the number of items
		
		return viewModel.photos.count
	}
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FlickrImageCell
		
		// Configure the cell
		
		let urlString = viewModel.photos[indexPath.row].urlSq
		
		let selectedIndexPath = IndexPath(item: indexPath.row, section: 0)
		
		let image = viewModel.image
		viewModel.downloadImage(collectionView: collectionView, from: urlString , indexPath: selectedIndexPath)
		
		cell.imageView.image = image
		
		cell.layer.cornerRadius = 8
		
		return cell
	}
	
	
	
	// MARK: UICollectionViewDelegate
	
	override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		
		print(indexPath.row)
		selectedPhotoId = viewModel.photos[indexPath.row]
		performSegue(withIdentifier: "toDetailView", sender: self)
		
	}
	
	override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
		let currentOffset = scrollView.contentOffset.y
		let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height

		if maximumOffset - currentOffset <= 10.0 && viewModel.isLoading == false{
			viewModel.isLoading = true
			if page < viewModel.pages {
				print(viewModel.pages)
				print(page)
				page += 1
				print(page)
				viewModel.getPhotos(view: view, page: page, collectionView: collectionView)
				viewModel.isLoading = false
			}
		}
	}
	
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		
		if segue.destination is DetailViewController  {
			let destVC = segue.destination as! DetailViewController
			destVC.selectedPhoto = selectedPhotoId
		}
	}
	
		
}

extension FlickrGalleryCVC: UICollectionViewDelegateFlowLayout {
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
		let availableWidth = view.frame.width - paddingSpace
		let widthPerItem = availableWidth / itemsPerRow
		
		return CGSize(width: widthPerItem, height: widthPerItem)
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		return sectionInsets
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return sectionInsets.left
	}
	
	
}
