//
//  SearchService.swift
//  AwayFromSaintP
//
//  Created by Dmitry Rozov on 20/11/2019.
//  Copyright © 2019 Dmitry Rozov. All rights reserved.
//

import Foundation

private let baseURL = "http://places.aviasales.ru/"

class SearchService {

    private var lastDataTask: URLSessionDataTask?

    func getDestinations(for query: String, complition: @escaping ([Destination]?, Error?) -> Void) {
        lastDataTask?.cancel()
        guard let urlString = "\(baseURL)places?locale=ru&term=\(query)"
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let url = URL(string: urlString) else {
                DispatchQueue.main.async {
                    complition(nil, NSError(domain: "", code: -1, userInfo: [:]))
                }
                return
        }

        lastDataTask = URLSession.shared.dataTask(with: url, completionHandler: { (data, _, error) in
            if let data = data,
                let destinations = try? JSONDecoder().decode([Destination].self, from: data) {
                DispatchQueue.main.async {
                    complition(destinations, nil)
                }
            } else {
                DispatchQueue.main.async {
                    complition(nil, error)
                }
            }
        })
        lastDataTask?.resume()
    }
}
