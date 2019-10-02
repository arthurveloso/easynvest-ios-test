//
//  SimulationResultsViewController.swift
//  Easynvest-iOS
//
//  Created by Arthur Melo on 28/09/19.
//  Copyright © 2019 Arthur Melo. All rights reserved.
//

import UIKit

class SimulationResultsViewController: UIViewController {

    var simulation: Simulation?
    var dueDate: String = ""

    @IBOutlet weak var investedAmount: UILabel!
    @IBOutlet weak var grossAmount: UILabel!
    @IBOutlet weak var grossAmountProfit: UILabel!
    @IBOutlet weak var taxesAmount: UILabel!
    @IBOutlet weak var netAmount: UILabel!
    @IBOutlet weak var maturityDate: UILabel!
    @IBOutlet weak var maturityTotalDays: UILabel!
    @IBOutlet weak var monthlyGrossRateProfit: UILabel!
    @IBOutlet weak var cdiRate: UILabel!
    @IBOutlet weak var yearlyInterestRate: UILabel!
    @IBOutlet weak var rateProfit: UILabel!
    @IBOutlet weak var simulationResult: UILabel!
    @IBOutlet weak var resultMessage: UILabel!
    @IBOutlet weak var resultView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        bindValues()
    }

    func bindValues() {
        guard let result = simulation else { return }

        investedAmount.text = "R$ \(result.investmentParameter.investedAmount)"
        simulationResult.text = "R$ \(result.grossAmount)"
        grossAmount.text = "R$ \(result.grossAmount)"
        resultMessage.attributedText = styleResult(value: "R$ \(result.grossAmountProfit)")
        grossAmountProfit.text = "R$ \(result.grossAmountProfit)"
        taxesAmount.text = "R$ \(result.taxesAmount)"
        netAmount.text = "R$ \(result.netAmount)"
        maturityDate.text = dueDate
        maturityTotalDays.text = "\(result.investmentParameter.maturityTotalDays)"
        monthlyGrossRateProfit.text = "\(result.monthlyGrossRateProfit)%"
        cdiRate.text = "\(result.investmentParameter.rate)%"
        yearlyInterestRate.text = "\(result.investmentParameter.yearlyInterestRate)%"
        rateProfit.text = "\(result.rateProfit)%"
    }

    func styleResult(value: String) -> NSAttributedString {
        let attrs1 = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),
                      NSAttributedString.Key.foregroundColor: UIColor.lightGray]

        let attrs2 = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),
                      NSAttributedString.Key.foregroundColor: UIColor(named: "easyCyan")]

        let attributedString1 = NSMutableAttributedString(string: "Rendimento total de ", attributes: attrs1)

        let attributedString2 = NSMutableAttributedString(string: value, attributes: attrs2 as
            [NSAttributedString.Key: Any])

        attributedString1.append(attributedString2)

        return attributedString1
    }

    @IBAction func simulateAgainButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
