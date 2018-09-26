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
}

@objc
public class ConsentDefaults: NSObject {
  var privacyPolicyURL: URL = URL.init(string: "https://www.abacus.ch/links/privacy-policy/mobile-apps")!
  var keyConsentTitle: String = "consent options title"
  var keyConsentMessage: String = "consent options message"
  var keyConsentOptionNoReportingTitle = "consent cell no reporting title"
  var keyConsentOptionNoReportingMessage = "consent cell no reporting message"
  var keyConsentOptionBugReportingTitle = "consent cell bug reporting title"
  var keyConsentOptionBugReportingMessage = "consent cell bug reporting message"
  var keyConsentOptionDiagnoseReportingTitle = "consent cell diagnose reporting title"
  var keyConsentOptionDiagnoseReportingMessage = "consent cell diagnose reporting message"
  var keyConsentConfirmation: String = "consent options button confirm"
  var keyConsentInformation: String = "consent options button information"
}

@objc
protocol ConsentScreenDelegate {
  func consentScreenCommited(chosenOption: ConsentOption)
}

class ConsentCell: UITableViewCell {
  var options: ConsentOptions?
  var defaults: ConsentDefaults?
  func setup(title t: String, message m: String) {
  }
}






class ConsentButtonCell: ConsentCell {
  let button = DLRadioButton()
  let title = UILabel()
  let message = UILabel()
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    title.textAlignment = .natural
    title.numberOfLines = 0
    title.font = UIFont.boldSystemFont(ofSize: 15)
    
    message.textAlignment = .natural
    message.numberOfLines = 0
    message.font = UIFont.systemFont(ofSize: 15)
    message.textColor = UIColor.brownishGrey
    
    button.iconSize = 23
    button.iconColor = UIColor.darkSkyBlue
    button.indicatorColor = UIColor.darkSkyBlue
    
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
    
    let recognizer = UITapGestureRecognizer.init(target: self, action: #selector(buttonTapped))
    addGestureRecognizer(recognizer)
  }
  
  override func setup(title t: String, message m: String) {
    title.text = t.localized()
    message.text = m.localized()
  }
  
  @objc func buttonTapped() {
    button.isSelected = true
  }
}

class ContentTitleCell: ConsentCell {
  
  var titleLabel = UILabel()
  var messageLabel = UILabel()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    addSubview(titleLabel)
    addSubview(messageLabel)
    titleLabel.textAlignment = .natural
    titleLabel.font = UIFont.boldSystemFont(ofSize: 22)
    titleLabel.numberOfLines = 0
    
    titleLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
    titleLabel.autoPinEdge(toSuperviewEdge: .leading, withInset: 0)
    titleLabel.autoPinEdge(toSuperviewEdge: .trailing, withInset: 0)
    
    messageLabel.autoPinEdge(.top, to: .bottom, of: titleLabel, withOffset: 0)
    messageLabel.autoConstrainAttribute(.leading, to: .leading, of: titleLabel)
    messageLabel.autoConstrainAttribute(.trailing, to: .trailing, of: titleLabel)
    messageLabel.autoPinEdge(toSuperviewEdge: .bottom)
    
    messageLabel.textAlignment = .natural
    messageLabel.font = UIFont.systemFont(ofSize: 15)
    messageLabel.numberOfLines = 0
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override func setup(title t: String, message m: String) {
    titleLabel.text = defaults?.keyConsentTitle.localized()
    messageLabel.text = defaults?.keyConsentMessage.localized()
  }

}

class ContentFooterCell: ConsentCell {
  
  var buttonConfirm = UIButton()
  var buttonInformation = UIButton()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    addSubview(buttonConfirm)
    addSubview(buttonInformation)
    
    buttonConfirm.layer.cornerRadius = 8
    buttonConfirm.layer.backgroundColor = UIColor.darkSkyBlue.cgColor
    buttonConfirm.setTitleColor(UIColor.white, for: .normal)
    buttonConfirm.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
    
    buttonConfirm.autoPinEdge(toSuperviewEdge: .leading, withInset: 20)
    buttonConfirm.autoPinEdge(toSuperviewEdge: .trailing, withInset: 20)
    buttonConfirm.autoSetDimension(.height, toSize: 50, relation: .greaterThanOrEqual)
    
    buttonInformation.autoPinEdge(toSuperviewEdge: .leading, withInset: 20)
    buttonInformation.autoPinEdge(toSuperviewEdge: .trailing, withInset: 20)
    buttonInformation.autoPinEdge(.top, to: .bottom, of: buttonConfirm, withOffset: 12)
    
    buttonInformation.setTitleColor(UIColor.darkSkyBlue, for: .normal)
    buttonInformation.titleLabel?.font = UIFont.systemFont(ofSize: 15)
    
    buttonConfirm.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    buttonInformation.addTarget(self, action: #selector(buttonInfoTapped), for: .touchUpInside)
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  @objc func buttonTapped() {
    print ("tapped")
  }
  
  override func setup(title t: String, message m: String) {
    buttonConfirm.setTitle(defaults?.keyConsentConfirmation.localized(), for: .normal)
    buttonInformation.setTitle(defaults?.keyConsentInformation.localized(), for: .normal)
  }
  
  @objc func buttonInfoTapped() {
    UIApplication.shared.open(defaults!.privacyPolicyURL, options: [:], completionHandler: nil)
  }

}









@objc
class ConsentViewController: UIViewController {
  
  public var options: ConsentOptions {
    didSet {
      updateViewConstraints()
    }
  }
  public var defaults = ConsentDefaults()
  var cells = [CellTypes]()
  var tableView = UITableView(frame: .zero, style: .plain)
  public var selectedOption: ConsentOption = .FullReporting
  
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
  
  enum CellTypes: String, CaseIterable {
    case title = "title"
    case fullReporting = "fullReporting"
    case bugReporting = "bugReporting"
    case noReporting = "noReporting"
    case footer = "footer"
  }
  
  func setup() {
    view.addSubview(tableView)
    tableView.autoPinEdgesToSuperviewMargins()
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(ContentTitleCell.self, forCellReuseIdentifier: CellTypes.title.rawValue)
    tableView.register(ContentFooterCell.self, forCellReuseIdentifier: CellTypes.footer.rawValue)
    tableView.register(ConsentButtonCell.self, forCellReuseIdentifier: CellTypes.fullReporting.rawValue)
    tableView.register(ConsentButtonCell.self, forCellReuseIdentifier: CellTypes.bugReporting.rawValue)
    tableView.register(ConsentButtonCell.self, forCellReuseIdentifier: CellTypes.noReporting.rawValue)
    view.backgroundColor = UIColor.white
    tableView.reloadData()
  }
  
}







extension ConsentViewController: UITableViewDataSource, UITableViewDelegate {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    cells.removeAll()
    cells.append(.title)
    if options.allowsNoReporting {
      cells.append(.noReporting)
    }
    if options.allowsBugReporting {
      cells.append(.bugReporting)
    }
    if options.allowsDiagnoseReporting {
      cells.append(.fullReporting)
    }
    cells.append(.footer)
    return 1;
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return cells.count;
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cellType = CellTypes.allCases[indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: cellType.rawValue) as! ConsentCell
    cell.options = options
    cell.defaults = defaults
    switch cellType {
    case .fullReporting:
        cell.setup(title: defaults.keyConsentOptionDiagnoseReportingTitle.localized(), message: defaults.keyConsentOptionDiagnoseReportingMessage.localized())
    case .noReporting:
        cell.setup(title: defaults.keyConsentOptionNoReportingTitle.localized(), message: defaults.keyConsentOptionDiagnoseReportingMessage.localized())
    case .bugReporting:
        cell.setup(title: defaults.keyConsentOptionBugReportingTitle.localized(), message: defaults.keyConsentOptionBugReportingMessage.localized())
    default:
      cell.setup(title: "", message: "")
    }
    return cell
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
  
  @nonobjc class var brownishGrey: UIColor {
    return UIColor(white: 102.0 / 255.0, alpha: 1.0)
  }
}
