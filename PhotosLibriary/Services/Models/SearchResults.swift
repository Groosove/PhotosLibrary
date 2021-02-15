//
//  searchResults.swift
//  PhotosLibriary
//
//  Created by Артур Лутфуллин on 13.03.2020.
//  Copyright © 2020 Артур Лутфуллин. All rights reserved.
//

import Foundation

struct SearchResults: Decodable {
	let total: Int
	let results: [UnsplashPhoto]
}

struct UnsplashPhoto: Decodable {
	let width: Int
	let height: Int
	let urls: [URLKing.RawValue:String]
	
	enum URLKing: String {
		case raw
		case full
		case regular
		case small
		case thumb
	}
}
