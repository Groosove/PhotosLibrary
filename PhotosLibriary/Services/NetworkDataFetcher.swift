//
//  NetworkDataFetcher.swift
//  PhotosLibriary
//
//  Created by Артур Лутфуллин on 13.03.2020.
//  Copyright © 2020 Артур Лутфуллин. All rights reserved.
//

import Foundation

class NetworkDataFetcher{
	
	var newtworkService = NetworkService()
	
	func gecthcImages(searchTerm: String, completion: @escaping (SearchResults?) -> ()) {
		newtworkService.request(searchTerm: searchTerm) { (data, error) in
			if let error = error {
				print("Error recieved requesting data: \(error.localizedDescription)")
				completion(nil)
			}
			
			let decoded = self.decodeJSON(type: SearchResults.self, from: data)
			completion(decoded)
			
		}
	}
	
	func decodeJSON<T: Decodable>(type: T.Type, from: Data?) -> T? {
		let decoder = JSONDecoder()
		guard let data = from else {return nil}
		
		do {
			let objects = try decoder.decode(type.self, from: data)
			return objects
		} catch let JSONError{
			print("Failed to decode JSON", JSONError)
			return nil
		}
	}
}
