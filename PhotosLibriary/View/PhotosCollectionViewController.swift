//
//  PhotosCollectionViewController.swift
//  PhotosLibriary
//
//  Created by Артур Лутфуллин on 13.03.2020.
//  Copyright © 2020 Артур Лутфуллин. All rights reserved.
//

import UIKit

class PhotosCollectionViewController: UICollectionViewController {
	
	var setColor: UIColor = .white
	var networkDataFetcher = NetworkDataFetcher()
	
	private var timer: Timer?
	
	private var photos = [UnsplashPhoto]()
	
	private var selectedImages = [UIImage]()
	
	private let itemsPerRow: CGFloat = 2
	
	private var numberOfSelectedPhoto: Int {
		return collectionView.indexPathsForSelectedItems?.count ?? 0
	}
	
	private let sectionInsert = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
	
	private lazy var actionBarButtonItem: UIBarButtonItem = {
		return UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(actionBarButtonTapped))
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		updateNavigationButtonState()
		setUpCollectionView()
		setUpNavigationBar()
		setUpSearchBar()
		collectionView.backgroundColor = .systemBackground
	}
	
	private func updateNavigationButtonState() {
		actionBarButtonItem.isEnabled = numberOfSelectedPhoto > 0
	}
	
	func refresh() {
		self.selectedImages.removeAll()
		self.collectionView.selectItem(at: nil, animated: true, scrollPosition: [])
		updateNavigationButtonState()
	}
	
	// MARK: - NavigationItems action
	@objc private func actionBarButtonTapped(sender: UIBarButtonItem){
		print(#function)
		
		let shareController = UIActivityViewController(activityItems: selectedImages, applicationActivities: nil)
		
		shareController.completionWithItemsHandler = { _, bool, _, _ in
			if bool {
				self.refresh()
			}
		}
		shareController.popoverPresentationController?.barButtonItem = sender
		shareController.popoverPresentationController?.permittedArrowDirections = .any
		present(shareController, animated: true, completion: nil)
	}
	
	// MARK: - Setup UI Elements
	private func setUpCollectionView(){
		collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "CellId")
		collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.reused)
		
		collectionView.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
		collectionView.contentInsetAdjustmentBehavior = .automatic
		collectionView.allowsMultipleSelection = true
	}
	
	private func setUpNavigationBar() {
		let titleLabel = UILabel()
		titleLabel.text = "PHOTOS"
		titleLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
		titleLabel.textColor = #colorLiteral(red: 0.5019607843, green: 0.4980392157, blue: 0.4980392157, alpha: 1)
		navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: titleLabel)
		
		navigationItem.rightBarButtonItems = [actionBarButtonItem]
	}
	
	private func setUpSearchBar(){
		let searchController = UISearchController(searchResultsController: nil)
		navigationItem.searchController = searchController
		searchController.hidesNavigationBarDuringPresentation = false
		searchController.obscuresBackgroundDuringPresentation = false
		searchController.searchBar.delegate = self
	}
	// MARK: - UICollectionViewDataSource, UICollectionViewDelegete
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return photos.count
	}
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.reused, for: indexPath) as! PhotoCell
		let unsplashPhoto = photos[indexPath.item]
		cell.unsplashPhoto = unsplashPhoto
		return cell
	}
	
	override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		updateNavigationButtonState()
		let cell = collectionView.cellForItem(at: indexPath) as! PhotoCell
		guard let image = cell.photoImageView.image else {return}
		selectedImages.append(image)
	}
	
	override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
		updateNavigationButtonState()
		let cell = collectionView.cellForItem(at: indexPath) as! PhotoCell
		guard let image = cell.photoImageView.image else {return}
		if let index = selectedImages.firstIndex(of: image) {
			selectedImages.remove(at: index)
		}
	}
}

// MARK: - UISearchBarDelegate

extension PhotosCollectionViewController: UISearchBarDelegate {
	
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		print(searchBar)
		
		timer?.invalidate()
		timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
			self.networkDataFetcher.gecthcImages(searchTerm: searchText) { [weak self](searchResults) in
				guard let fetchPhotos = searchResults else {return}
				self?.photos = fetchPhotos.results
				self?.collectionView.reloadData()
				self?.refresh()
			}
		})
		
	}
}

// MARK: - UICollectionViewDelegateFlowLayout
extension PhotosCollectionViewController: UICollectionViewDelegateFlowLayout {
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let photo = photos[indexPath.item]
		let paddingSpace = sectionInsert.left * (itemsPerRow + 1)
		let availableWidth = view.frame.width - paddingSpace
		let widthPerItem = availableWidth / itemsPerRow
		let height = CGFloat(photo.height) * widthPerItem / CGFloat(photo.width)
		return CGSize(width: widthPerItem , height: height)
		
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		return sectionInsert
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return sectionInsert.left
	}
}
