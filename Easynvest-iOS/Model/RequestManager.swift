//
//  RequestManager.swift
//  Easynvest-iOS
//
//  Created by Arthur Melo on 28/09/19.
//  Copyright © 2019 Arthur Melo. All rights reserved.
//

import Foundation

class RequestManager {
    static let shared = RequestManager()

    func getSimulation(for value: String,
                       date: String,
                       cdiRate: String,
                       onSuccess: @escaping(Simulation) -> Void,
                       onFailure: @escaping(Error) -> Void) {

        var components = URLComponents()
        components.scheme = "https"
        components.host = "api-simulator-calc.easynvest.com.br"
        components.path = "/calculator/simulate"
        components.queryItems = [
            URLQueryItem(name: "investedAmount", value: value),
            URLQueryItem(name: "index", value: "CDI"),
            URLQueryItem(name: "rate", value: cdiRate),
            URLQueryItem(name: "isTaxFree", value: "true"),
            URLQueryItem(name: "maturityDate", value: date)
        ]

        guard let url = components.url else { return }
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                let gitData = try decoder.decode(Simulation.self, from: data)
                onSuccess(gitData)
            } catch let error {
                onFailure(error)
            }
        }.resume()
    }
}
