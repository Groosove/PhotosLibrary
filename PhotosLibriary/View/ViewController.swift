//
//  ViewController.swift
//  PhotosLibriary
//
//  Created by Артур Лутфуллин on 13.03.2020.
//  Copyright © 2020 Артур Лутфуллин. All rights reserved.
//

import UIKit

class ViewController: UITabBarController {

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		
		view.backgroundColor = .gray
		
		let photosVC = PhotosCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
		viewControllers = [
			generateNagigationController(rootViewController: photosVC, tittle: "Photos", image: #imageLiteral(resourceName: "photos")),
//			generateNagigationController(rootViewController: MainTabBarCollection() , tittle: "Favourite", image: #imageLiteral(resourceName: "heart"))
		]
	}
	private func generateNagigationController(rootViewController: UIViewController, tittle: String, image: UIImage) -> UIViewController{
		let navigationVC = UINavigationController(rootViewController: rootViewController)
		navigationVC.tabBarItem.title = tittle
		navigationVC.tabBarItem.image = image
		return navigationVC
	}
}

