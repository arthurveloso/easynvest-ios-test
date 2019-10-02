//
//  SimulationFormViewController.swift
//  Easynvest-iOS
//
//  Created by Arthur Melo on 27/09/19.
//  Copyright © 2019 Arthur Melo. All rights reserved.
//

import UIKit

class SimulationFormViewController: UIViewController {

    @IBOutlet weak var investedAmount: UITextField!
    @IBOutlet weak var investmentDueDate: UITextField!
    @IBOutlet weak var cdiRate: UITextField!
    @IBOutlet weak var simulateButton: UIButton!

    var simulation: Simulation?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setButtonStates()
        configTextFields()
        setAccessibilityIdentifiers()
    }

    @objc func editingChanged(_ textField: UITextField) {
        if textField == investedAmount {
            if !textField.text!.contains("R$ ") {
                textField.text = "R$ \(textField.text!)"
            }
        } else if textField == cdiRate {
            if !textField.text!.contains("%") {
                textField.text = "\(textField.text!)%"
            } else {
                let textArray = textField.text!.components(separatedBy: "%")
                let oldValue = textArray[0]
                let addedValue = textArray[1]
                let newValue = oldValue + addedValue
                textField.text = "\(newValue)%"
            }
        }
        if investedAmount.text != "" && investmentDueDate.text != "" && cdiRate.text != ""{
            simulateButton.isEnabled = true
        }
    }

    @IBAction func simulate(_ sender: UIButton) {
        guard let amount = investedAmount.text else { return }

        guard let date = investmentDueDate.text else { return }

        guard let rate = cdiRate.text else { return }

        let amountArray = amount.components(separatedBy: "R$ ")
        let rawAmount = amountArray[1]

        let dateArray = date.components(separatedBy: "/")
        var rawDate = date
        if dateArray.count == 3 {
            rawDate = "\(dateArray[2])-\(dateArray[1])-\(dateArray[0])"
        }

        let rateArray = rate.components(separatedBy: "%")
        let rawRate = rateArray[0]

        let form = Form(amount: rawAmount, date: rawDate, rate: rawRate)

        RequestManager.shared.getSimulation(form: form,
                                            onSuccess: { (simulation) in
                                                self.simulation = simulation
                                                DispatchQueue.main.async {
                                                    self.performSegue(withIdentifier: "segue", sender: nil)
                                                }
        }, onFailure: { error in
            print(error.localizedDescription)
        })
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segue" {
            guard let resultViewController = segue.destination
                as? SimulationResultsViewController else { return }
            guard let simulation = self.simulation else { return }
            resultViewController.simulation = simulation
            guard let date = investmentDueDate.text else { return }
            resultViewController.dueDate = date
        }
    }

    func setButtonStates() {
        guard let gray = UIColor(named: "easyGray") else { return }
        guard let cyan = UIColor(named: "easyCyan") else { return }
        self.simulateButton.setBackgroundColor(color: gray, forState: .disabled)
        self.simulateButton.setBackgroundColor(color: cyan, forState: .normal)
    }

    func configTextFields() {
        self.hideKeyboardWhenTappedAround()
        investmentDueDate.delegate = self
        investedAmount.delegate = self
        cdiRate.delegate = self
        investedAmount.addTarget(self, action: #selector(editingChanged(_:)), for: .editingChanged)
        cdiRate.addTarget(self, action: #selector(editingChanged(_:)), for: .editingChanged)
    }
    
    func setAccessibilityIdentifiers() {
        investedAmount.accessibilityIdentifier = "amount"
        investmentDueDate.accessibilityIdentifier = "date"
        cdiRate.accessibilityIdentifier = "rate"
        simulateButton.accessibilityIdentifier = "simulate"
    }
}

extension SimulationFormViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        if !CharacterSet(charactersIn: "0123456789").isSuperset(of: CharacterSet(charactersIn: string)) {
            return false
        }
        if textField == investmentDueDate {
            if (textField.text?.count == 2) || (textField.text?.count == 5) {
                if !(string == "") {
                    textField.text = (textField.text)! + "/"
                }
            }
            return !(textField.text!.count > 9 && (string.count ) > range.length)
        } else if textField == investedAmount {
            return !(textField.text!.count > 15 && (string.count ) > range.length)
        } else {
            return !(textField.text!.count > 3 && (string.count ) > range.length)
        }
    }
}
