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

    var simulation: Simulation?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        investmentDueDate.delegate = self
    }

    @IBAction func simulate(_ sender: UIButton) {
        guard let amount = investedAmount.text else { return }

        guard let date = investmentDueDate.text else { return }

        guard let rate = cdiRate.text else { return }

        let dateArray = date.components(separatedBy: "/")
        var newDate = date
        if dateArray.count == 3 {
            newDate = "\(dateArray[2])-\(dateArray[1])-\(dateArray[0])"
        }

        RequestManager.shared.getSimulation(for: amount,
                                            date: newDate,
                                            cdiRate: rate,
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
}

extension SimulationFormViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
            if (textField.text?.count == 2) || (textField.text?.count == 5) {
                if !(string == "") {
                    textField.text = (textField.text)! + "/"
                }
            }
            return !(textField.text!.count > 9 && (string.count ) > range.length)
    }
}
