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
    let vc = ConsentViewController.init(nibName: nil, bundle: nil)
    vc.delegate = self
    present(vc, animated: true, completion: nil)
  }
  
  func consentScreenCommited(chosenOption: ConsentOption) {
    print ("You chose option \(chosenOption.rawValue)")
  }
  
}

