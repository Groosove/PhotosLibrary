//
//  PhotoCell.swift
//  PhotosLibriary
//
//  Created by Артур Лутфуллин on 14.03.2020.
//  Copyright © 2020 Артур Лутфуллин. All rights reserved.
//

import UIKit
import SDWebImage

class PhotoCell: UICollectionViewCell {
	
	static let reused = "PhotoCell"
	
	private let checkMark: UIImageView = {
		let image = #imageLiteral(resourceName: "bird")
		let imageView = UIImageView(image: image)
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.alpha = 0
		return imageView
	}()
	
	 let photoImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
		imageView.contentMode = .scaleAspectFill
		return imageView
	}()
	
	var unsplashPhoto: UnsplashPhoto! {
		didSet {
			let photourl = unsplashPhoto.urls["regular"]
			guard let imageUrl = photourl, let url = URL(string: imageUrl) else {return}
			photoImageView.sd_setImage(with: url, completed: nil)
		}
	}
	override var isSelected: Bool{
		didSet {
			updateSelectedState()
		}
	}

	override func prepareForReuse() {
		super.prepareForReuse()
		photoImageView.image = nil
	}
	
	private func updateSelectedState() {
		photoImageView.alpha = isSelected ? 0.7 : 1
		checkMark.alpha = isSelected ? 1 : 0
	}
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		updateSelectedState()
		setupPhotoImageView()
		setupCheckMarkView()
	}
	
	private func setupPhotoImageView() {
		addSubview(photoImageView)
		photoImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
		photoImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
		photoImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
		photoImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
	}
	
	private func setupCheckMarkView() {
		addSubview(checkMark)
		checkMark.trailingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: -8).isActive = true
		checkMark.bottomAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: 8).isActive = true
	}
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
