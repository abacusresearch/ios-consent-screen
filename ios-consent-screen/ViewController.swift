//
//  ViewController.swift
//  ios-consent-screen
//
//  Created by Roger Misteli on 24.09.18.
//  Copyright © 2018 ABACUS Research AG. All rights reserved.
//

import UIKit

class ViewController: UIViewController, ConsentScreenDelegate {

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }

  @IBAction func tapped(_ sender: Any) {
    let vc = ConsentViewController()
    let options = ConsentOptions()
    options.allowsDiagnoseReporting = false
    options.allowsNoReporting = true
    options.allowsBugReporting = true
    vc.options = options
    vc.delegate = self
    vc.modalPresentationStyle = .formSheet
    present(vc, animated: true, completion: nil)
  }
  
  func consentScreenCommited(chosenOption: ConsentOption) {
    dismiss(animated: true) {
      print ("You chose option \(chosenOption.rawValue)")
    }
  }

}

