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

    func getSimulation(form: Form,
                       onSuccess: @escaping(Simulation) -> Void,
                       onFailure: @escaping(Error) -> Void) {
        guard let amount = form.amount else { return }
        guard let date = form.date else { return }
        guard let rate = form.rate else { return }

        var components = URLComponents()
        components.scheme = "https"
        components.host = "api-simulator-calc.easynvest.com.br"
        components.path = "/calculator/simulate"
        components.queryItems = [
            URLQueryItem(name: "investedAmount", value: amount),
            URLQueryItem(name: "index", value: "CDI"),
            URLQueryItem(name: "rate", value: rate),
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

    func getMockedSimulationData(from mockedForm: Form, onSuccess: @escaping(Data) -> Void) {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api-simulator-calc.easynvest.com.br"
        components.path = "/calculator/simulate"
        components.queryItems = [
            URLQueryItem(name: "investedAmount", value: mockedForm.amount),
            URLQueryItem(name: "index", value: "CDI"),
            URLQueryItem(name: "rate", value: mockedForm.rate),
            URLQueryItem(name: "isTaxFree", value: "true"),
            URLQueryItem(name: "maturityDate", value: mockedForm.date)
        ]

        guard let url = components.url else { return }
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            guard let data = data else { return }
            onSuccess(data)
        }.resume()
    }
}
