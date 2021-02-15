//
//  networkService.swift
//  PhotosLibriary
//
//  Created by Артур Лутфуллин on 13.03.2020.
//  Copyright © 2020 Артур Лутфуллин. All rights reserved.
//

import Foundation

class NetworkService {
	// построение запроса по URL
	func request(searchTerm: String, complition: @escaping(Data?,Error?)->Void){
		let params = self.prepareParametrs(searchTerm: searchTerm)
		let url = self.url(params: params)
		var request = URLRequest(url: url)
		
		request.allHTTPHeaderFields = prepareHeaders()
		request.httpMethod = "get"
		let task = createDataTask(from: request, complition: complition)
		task.resume()
	}
	// Запрос на сайт unsplash c помощью ключа
	private func prepareHeaders() -> [String: String]? {
		var headers = [String: String]()
		headers["Authorization"] = "Client-ID G_2NpDD8PkYRhUiecFxM_nHHGaXuyNbdEfjtkSb1Nes"
		return headers
	}
	private func prepareParametrs(searchTerm: String?) -> [String: String]{
		var parametrs = [String: String]()
		parametrs["query"] = searchTerm
		parametrs["page"] = String(1)
		parametrs["per_page"] = String(50)
		return parametrs
	}
	private func url(params: [String: String]) -> URL {
		var components = URLComponents()
		
		components.scheme = "https"
		components.host = "api.unsplash.com"
		components.path = "/search/photos"
		components.queryItems = params.map {URLQueryItem(name: $0, value: $1)}
		return components.url!
	}
	
	private func createDataTask(from request: URLRequest, complition: @escaping(Data?, Error?)->Void) -> URLSessionDataTask {
		return URLSession.shared.dataTask(with: request) { (data, response, error) in
			DispatchQueue.main.sync {
				complition(data, error)
			}
		}
	}
}
