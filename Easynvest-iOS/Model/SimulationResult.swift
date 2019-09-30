//
//  SimulationResult.swift
//  Easynvest-iOS
//
//  Created by Arthur Melo on 28/09/19.
//  Copyright © 2019 Arthur Melo. All rights reserved.
//

import Foundation

struct Simulation: Codable {
    let investmentParameter: InvestmentParameter
    let grossAmount, taxesAmount, netAmount, grossAmountProfit: Double
    let netAmountProfit, annualGrossRateProfit, monthlyGrossRateProfit, dailyGrossRateProfit: Double
    let taxesRate: Int
    let rateProfit, annualNetRateProfit: Double
}

struct InvestmentParameter: Codable {
    let investedAmount: Int
    let yearlyInterestRate: Double
    let maturityTotalDays, maturityBusinessDays: Int
    let maturityDate: String
    let rate: Int
    let isTaxFree: Bool
}
