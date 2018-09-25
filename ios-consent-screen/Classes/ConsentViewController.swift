//
//  ConsentViewController.swift
//  ios-consent-screen
//
//  Created by Roger Misteli on 24.09.18.
//  Copyright © 2018 ABACUS Research AG. All rights reserved.
//

import UIKit
import PureLayout
import DLRadioButton

@objc
enum ConsentOption: Int {
  case NoReporting = 0
  case BugReporting = 1
  case FullReporting = 2
}

@objc
public class ConsentOptions: NSObject {
  var allowsDiagnoseReporting: Bool = true
  var allowsBugReporting: Bool = true
  var allowsNoReporting: Bool = true
  var privacyPolicyURL: URL = URL.init(string: "https://www.abacus.ch/links/privacy-policy/mobile-apps")!
}

@objc
protocol ConsentScreenDelegate {
  func consentScreenCommited(chosenOption: ConsentOption)
}

class ConsentButton: UIView {
  let button = DLRadioButton()
  let title = UILabel()
  let message = UILabel()
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  init(title t: String, message m: String) {
    super.init(frame: .zero)
    title.text = t.localized()
    message.text = m.localized()
    
    title.textAlignment = .natural
    title.numberOfLines = 0
    title.font = UIFont.boldSystemFont(ofSize: 15)
    
    message.textAlignment = .natural
    message.numberOfLines = 0
    message.font = UIFont.systemFont(ofSize: 15)
    message.textColor = UIColor.lightGray
    
    button.iconSize = 23
    button.iconColor = UIColor.darkSkyBlue
    
    addSubview(button)
    addSubview(title)
    addSubview(message)
    
    button.autoPinEdge(toSuperviewEdge: .top)
    button.autoPinEdge(toSuperviewEdge: .leading)
    button.autoSetDimensions(to: CGSize.init(width: 23, height: 23))

    title.autoPinEdge(.leading, to: .trailing, of: button, withOffset: 8)
    title.autoAlignAxis(.horizontal, toSameAxisOf: button)
    title.autoPinEdge(toSuperviewEdge: .trailing)
    title.autoSetDimension(.height, toSize: 23, relation: .greaterThanOrEqual)
    
    message.autoPinEdge(.top, to: .bottom, of: title, withOffset: 2)
    message.autoConstrainAttribute(.leading, to: .leading, of: title)
    message.autoConstrainAttribute(.trailing, to: .trailing, of: title)
    message.autoSetDimension(.height, toSize: 23, relation: .greaterThanOrEqual)
    message.autoPinEdge(toSuperviewEdge: .bottom)
  }
}

@objc
class ConsentViewController: UIViewController {
  
  public var options: ConsentOptions {
    didSet {
      updateViewConstraints()
    }
  }
  public var selectedOption: ConsentOption = .FullReporting
  let titleLabel = UILabel()
  let messageLabel = UILabel()
  let buttonConfirm = UIButton()
  let buttonInformation = UIButton()
  let optionPanel = UIView()
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    options = ConsentOptions()
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    options = ConsentOptions()
    super.init(coder: aDecoder)
    setup()
  }
  
  func setup() {
    view.addSubview(titleLabel)
    view.addSubview(messageLabel)
    view.addSubview(optionPanel)
    view.addSubview(buttonConfirm)
    view.addSubview(buttonInformation)

    titleLabel.textAlignment = .center
    titleLabel.font = UIFont.boldSystemFont(ofSize: 22)
    titleLabel.text = "consent options title label".localized()
    titleLabel.numberOfLines = 0

    titleLabel.autoPin(toTopLayoutGuideOf: self, withInset: 50)
    titleLabel.autoPinEdge(toSuperviewMargin: .leading, withInset: 20)
    titleLabel.autoPinEdge(toSuperviewMargin: .trailing, withInset: 20)
    
    messageLabel.autoPinEdge(.top, to: .bottom, of: titleLabel, withOffset: 20)
    messageLabel.autoConstrainAttribute(.leading, to: .leading, of: titleLabel)
    messageLabel.autoConstrainAttribute(.trailing, to: .trailing, of: titleLabel)
    messageLabel.textAlignment = .natural
    messageLabel.font = UIFont.systemFont(ofSize: 15)
    messageLabel.text = "consent options message label"
    messageLabel.numberOfLines = 0
    
    optionPanel.autoPinEdge(toSuperviewMargin: .leading, withInset: 20)
    optionPanel.autoPinEdge(toSuperviewMargin: .trailing, withInset: 20)
    optionPanel.autoPinEdge(.top, to: .bottom, of: messageLabel, withOffset: 20)
    
    buttonConfirm.layer.cornerRadius = 8
    buttonConfirm.layer.backgroundColor = UIColor.darkSkyBlue.cgColor
    buttonConfirm.setTitleColor(UIColor.white, for: .normal)
    buttonConfirm.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
    buttonConfirm.setTitle("consent options confirm title".localized(), for: .normal)
    
    buttonConfirm.autoPinEdge(toSuperviewMargin: .leading, withInset: 20)
    buttonConfirm.autoPinEdge(toSuperviewMargin: .trailing, withInset: 20)
    buttonConfirm.autoPinEdge(.top, to: .bottom, of: optionPanel, withOffset: 20)
    buttonConfirm.autoSetDimension(.height, toSize: 50, relation: .greaterThanOrEqual)
    
    buttonInformation.autoPinEdge(toSuperviewMargin: .leading, withInset: 20)
    buttonInformation.autoPinEdge(toSuperviewMargin: .trailing, withInset: 20)
    buttonInformation.autoPinEdge(.top, to: .bottom, of: buttonConfirm, withOffset: 12)
    buttonInformation.setTitle("consent options information title".localized(), for: .normal)
    
    buttonInformation.setTitleColor(UIColor.darkSkyBlue, for: .normal)
    buttonInformation.titleLabel?.font = UIFont.systemFont(ofSize: 15)
    
    buttonConfirm.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    buttonInformation.addTarget(self, action: #selector(buttonInfoTapped), for: .touchUpInside)

    view.backgroundColor = UIColor.white
  }
  
  @IBAction func buttonTapped() {
    
  }
  
  @IBAction func buttonInfoTapped() {
    UIApplication.shared.open(options.privacyPolicyURL, options: [:], completionHandler: nil)
  }
  
  override func updateViewConstraints() {
    optionPanel.subviews.forEach { $0.removeFromSuperview() }
    var buttons = [ConsentButton]()
    if (self.options.allowsNoReporting) {
      buttons.append(ConsentButton.init(title: "consent button no reporting title", message: "consent button no reporting message"))
    }
    if (self.options.allowsBugReporting) {
      buttons.append(ConsentButton.init(title: "consent button bug reporting title", message: "consent button bug reporting message"))
    }
    if (self.options.allowsDiagnoseReporting) {
      buttons.append(ConsentButton.init(title: "consent button diagnose reporting title", message: "consent button diagnose reporting message"))
    }
    buttons.forEach { (button) in
      optionPanel.addSubview(button)
      button.autoPinEdge(toSuperviewEdge: .leading)
      button.autoPinEdge(toSuperviewEdge: .trailing)
    }
    if let thebuttons = buttons as? NSArray {
      thebuttons.autoDistributeViews(along: .vertical, alignedTo: .leading, withFixedSpacing: 20)
    }
    let radios = buttons.map { (button) -> DLRadioButton in
      return button.button
    }
    buttons[selectedOption.rawValue].button.isSelected = true
    radios.forEach { (button) in
      button.otherButtons = radios
    }
    
    super.updateViewConstraints()
  }
  
}


extension String {
  
  func localized(withComment comment: String? = nil) -> String {
    let bundle = Bundle.init(for: ConsentViewController.self)
    return NSLocalizedString(self, bundle: bundle, comment: comment ?? "")
  }
  
}


extension UIColor {
  @nonobjc class var darkSkyBlue: UIColor {
    return UIColor(red: 54.0 / 255.0, green: 129.0 / 255.0, blue: 221.0 / 255.0, alpha: 1.0)
  }

}
