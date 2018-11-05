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
public enum ConsentOption: Int {
  /// this setting allows no reporting at all, neither analytics nor crash reports nor logging
  case noReporting = 0
  
  /// this setting allows bug reporting, that is, crash reports and log files, but no analytics
  case bugReporting = 1
  
  /// this setting allows full reprting, that is, log files, crash reports, log files and whatsoever
  case fullReporting = 2
}

@objc
public enum ConsentMode: Int {
  /// defines either cells and headers or cells only depending on the bounds of the view controller
  case automatic = 0
  
  /// defines that the tableview will use cells only. This is usually the case when the whole tableview can be displayed
  case cellsOnly = 1
  
  /// defines that the tableview will display headers, footers and cells. The header and footer will not move whereas the subtitle and cells will
  case cellsAndHeaderFooters = 2
}

@objc
public class ConsentOptions: NSObject {
  /// allow full reporting as selectable option in the consent view controller
  @objc public var allowsDiagnoseReporting: Bool = true
  
  /// allow bug reporting as selectable option in the consent view controller
  @objc public var allowsBugReporting: Bool = true
  
  /// allow no reporting as selectable option in the consent view controller
  @objc public var allowsNoReporting: Bool = true
}

@objc
/// override these keys if your localizable strings has other content to use
public class ConsentDefaults: NSObject {
  /// the bundle to use for localized strings
  @objc public var bundle: Bundle = Bundle(for: ConsentDefaults.self)
  
  /// the URL of the privacy policy link to direct to when "more information" is tapped
  @objc public var privacyPolicyURL: URL = URL.init(string: "https://www.abacus.ch/links/privacy-policy/mobile-apps")!
  
  @objc public var keyConsentTitle: String = "consent options title"
  @objc public var keyConsentMessage: String = "consent options message"
  @objc public var keyConsentOptionNoReportingTitle = "consent cell no reporting title"
  @objc public var keyConsentOptionNoReportingMessage = "consent cell no reporting message"
  @objc public var keyConsentOptionBugReportingTitle = "consent cell bug reporting title"
  @objc public var keyConsentOptionBugReportingMessage = "consent cell bug reporting message"
  @objc public var keyConsentOptionDiagnoseReportingTitle = "consent cell diagnose reporting title"
  @objc public var keyConsentOptionDiagnoseReportingMessage = "consent cell diagnose reporting message"
  @objc public var keyConsentConfirmation: String = "consent options button confirm"
  @objc public var keyConsentInformation: String = "consent options button information"
}

enum CellTypes: String, CaseIterable {
  case title = "title"
  case subTitle = "subTitle"
  case fullReporting = "fullReporting"
  case bugReporting = "bugReporting"
  case noReporting = "noReporting"
  case footer = "footer"
}

struct ConsentUIDefaults {
  static let leadingOffset: CGFloat = 10
  static let topOffset: CGFloat = 10
  static let cellOffset: CGFloat = 20
  static let bottomOffset: CGFloat = 10
  static let trailingOffset: CGFloat = 10
  static let titleOffset: CGFloat = 10
  static let detailOffset: CGFloat = 2
  static let blockOffset: CGFloat = 25
  static let minimumHeightForSwitchMode: CGFloat = 600
}

@objc
public protocol ConsentScreenDelegate {
  /// tells the delegate that the dialog has been committed with the chosen consent option
  func consentScreenCommited(chosenOption: ConsentOption)
}

protocol ConsentCellDelegate {
  func consentCellTapped(chosenCell: CellTypes)
}

protocol ConsentCellProtocol {
  var options: ConsentOptions? { get }
  var defaults: ConsentDefaults? { get }
  var delegate: ConsentCellDelegate? { get }
  func setup(title t: String, message m: String)
}

class ConsentCell: UITableViewCell, ConsentCellProtocol {
  var options: ConsentOptions?
  var defaults: ConsentDefaults?
  var delegate: ConsentCellDelegate?
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
    
    button.autoPinEdge(toSuperviewEdge: .top, withInset: ConsentUIDefaults.topOffset)
    button.autoPinEdge(toSuperviewEdge: .leading, withInset: ConsentUIDefaults.leadingOffset)
    button.autoSetDimensions(to: CGSize.init(width: 23, height: 23))
    
    title.autoPinEdge(.leading, to: .trailing, of: button, withOffset: 8)
    title.autoAlignAxis(.horizontal, toSameAxisOf: button)
    title.autoPinEdge(toSuperviewEdge: .trailing, withInset:ConsentUIDefaults.bottomOffset)
    title.autoSetDimension(.height, toSize: 23, relation: .greaterThanOrEqual)
    
    message.autoPinEdge(.top, to: .bottom, of: title, withOffset: ConsentUIDefaults.detailOffset)
    message.autoConstrainAttribute(.leading, to: .leading, of: title)
    message.autoConstrainAttribute(.trailing, to: .trailing, of: title)
    message.autoSetDimension(.height, toSize: 23, relation: .greaterThanOrEqual)
    message.autoPinEdge(toSuperviewEdge: .bottom, withInset: ConsentUIDefaults.bottomOffset)
    
    let recognizer = UITapGestureRecognizer.init(target: self, action: #selector(buttonTapped))
    addGestureRecognizer(recognizer)
    
    button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
  }
  
  override func setup(title t: String, message m: String) {
    title.text = t.localized(withBundle: defaults?.bundle)
    message.text = m.localized(withBundle: defaults?.bundle)
  }
  
  @objc func buttonTapped() {
    button.isSelected = true
    self.delegate?.consentCellTapped(chosenCell: CellTypes(rawValue: self.reuseIdentifier!)!)
  }
}






class ConsentTitle: UIView, ConsentCellProtocol {
  var titleLabel = UILabel()
  var options: ConsentOptions?
  var defaults: ConsentDefaults?
  var delegate: ConsentCellDelegate?

  init() {
    super.init(frame: .zero)
    addSubview(titleLabel)
    titleLabel.textAlignment = .natural
    titleLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
    titleLabel.numberOfLines = 0
    
    titleLabel.autoPinEdge(toSuperviewEdge: .top, withInset: ConsentUIDefaults.topOffset)
    titleLabel.autoPinEdge(toSuperviewEdge: .leading, withInset: ConsentUIDefaults.leadingOffset)
    titleLabel.autoPinEdge(toSuperviewEdge: .trailing, withInset: ConsentUIDefaults.trailingOffset)
    titleLabel.autoPinEdge(toSuperviewEdge: .bottom, withInset: ConsentUIDefaults.bottomOffset)
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(frame: .zero)
  }
  
  func setup(title t: String, message m: String) {
    titleLabel.text = defaults?.keyConsentTitle.localized(withBundle: defaults?.bundle)
  }
}






class ConsentSubtitle: UIView, ConsentCellProtocol {
  var messageLabel = UILabel()
  var options: ConsentOptions?
  var defaults: ConsentDefaults?
  var delegate: ConsentCellDelegate?

  init() {
    super.init(frame: .zero)
    addSubview(messageLabel)
    messageLabel.autoPinEdge(toSuperviewEdge: .top, withInset: ConsentUIDefaults.topOffset)
    messageLabel.autoPinEdge(toSuperviewEdge: .leading, withInset: ConsentUIDefaults.leadingOffset)
    messageLabel.autoPinEdge(toSuperviewEdge: .trailing, withInset: ConsentUIDefaults.trailingOffset)
    messageLabel.autoPinEdge(toSuperviewEdge: .bottom, withInset: ConsentUIDefaults.blockOffset)
    
    messageLabel.textAlignment = .natural
    messageLabel.font = UIFont.systemFont(ofSize: 15)
    messageLabel.numberOfLines = 0
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(frame: .zero)
  }
  
  func setup(title t: String, message m: String) {
    messageLabel.text = m
  }
}






class ConsentTitleCell: ConsentCell {
  
  var title = ConsentTitle()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    addSubview(title)
    title.autoPinEdgesToSuperviewEdges()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override func setup(title t: String, message m: String) {
    super.setup(title: t, message: m)
    title.titleLabel.text = defaults?.keyConsentTitle.localized(withBundle: defaults?.bundle)
  }
  
}






class ConsentSubtitleCell: ConsentCell {
  
  var title = ConsentSubtitle()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    addSubview(title)
    title.autoPinEdgesToSuperviewEdges()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override func setup(title t: String, message m: String) {
    super.setup(title: t, message: m)
    title.messageLabel.text = defaults?.keyConsentMessage.localized(withBundle: defaults?.bundle)
  }
}






class ConsentHeaderFooterView: UITableViewHeaderFooterView, ConsentCellProtocol {
  var options: ConsentOptions?
  var defaults: ConsentDefaults?
  var delegate: ConsentCellDelegate?

  func setup(title t: String, message m: String) {
  }
}

class ConsentFooterView: UIView, ConsentCellProtocol {
  
  var options: ConsentOptions?
  var defaults: ConsentDefaults?
  var delegate: ConsentCellDelegate?

  var buttonConfirm = UIButton()
  var buttonInformation = UIButton()

  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(buttonConfirm)
    addSubview(buttonInformation)
    
    buttonConfirm.layer.cornerRadius = 8
    buttonConfirm.layer.backgroundColor = UIColor.darkSkyBlue.cgColor
    buttonConfirm.setTitleColor(UIColor.white, for: .normal)
    buttonConfirm.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
    
    buttonConfirm.autoPinEdge(toSuperviewEdge: .top, withInset: 20)
    buttonConfirm.autoPinEdge(toSuperviewEdge: .leading, withInset: ConsentUIDefaults.leadingOffset)
    buttonConfirm.autoPinEdge(toSuperviewEdge: .trailing, withInset: ConsentUIDefaults.trailingOffset)
    buttonConfirm.autoSetDimension(.height, toSize: 50, relation: .greaterThanOrEqual)
    
    buttonInformation.autoPinEdge(toSuperviewEdge: .leading, withInset: ConsentUIDefaults.leadingOffset)
    buttonInformation.autoPinEdge(toSuperviewEdge: .trailing, withInset: ConsentUIDefaults.trailingOffset)
    buttonInformation.autoPinEdge(.top, to: .bottom, of: buttonConfirm, withOffset: 30)
    buttonInformation.autoPinEdge(toSuperviewEdge: .bottom, withInset: 30)
    //buttonInformation.autoSetDimension(.height, toSize: 50, relation: .greaterThanOrEqual)
    
    buttonInformation.setTitleColor(UIColor.red, for: .normal)
    buttonInformation.titleLabel?.font = UIFont.systemFont(ofSize: 15)
    
    buttonConfirm.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    buttonInformation.addTarget(self, action: #selector(buttonInfoTapped), for: .touchUpInside)
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(frame: .zero)
  }
  
  @objc func buttonTapped() {
    self.delegate?.consentCellTapped(chosenCell: .footer)
  }
  
  @objc func buttonInfoTapped() {
    UIApplication.shared.open(defaults!.privacyPolicyURL, options: [:], completionHandler: nil)
  }
  
  func setup(title t: String, message m: String) {
    buttonConfirm.setTitle(defaults?.keyConsentConfirmation.localized(withBundle: defaults?.bundle), for: .normal)
    guard var text = defaults?.keyConsentInformation.localized(withBundle: defaults?.bundle) else {
      return
    }
    
    buttonInformation.titleLabel?.numberOfLines = 0
    
    if text.contains("<") && text.contains(">") {
      // Either I'm too fucking stupid or ranges in Swift are a fucking mess to deal with (probably both)
      let startRange = NSRange(text.range(of: "<")!, in:text)
      let endRange = NSRange(text.range(of: ">")!, in:text)
      let range = NSUnionRange(startRange, endRange)
      text = text.replacingOccurrences(of: "<", with: " ")
      text = text.replacingOccurrences(of: ">", with: " ")
      let title = NSMutableAttributedString(string: text, attributes: [NSAttributedString.Key.foregroundColor: UIColor.brownishGrey])
      title.setAttributes([NSAttributedString.Key.foregroundColor: UIColor.darkSkyBlue], range: range)
      buttonInformation.setAttributedTitle(title, for: .normal)
    }
  }

}




class ConsentFooter: ConsentHeaderFooterView {

  var footer = ConsentFooterView()
  
  override init(reuseIdentifier: String?) {
    super.init(reuseIdentifier: reuseIdentifier)

    addSubview(footer)
    footer.autoPinEdgesToSuperviewEdges()
    self.backgroundView = UIView()
    self.backgroundView!.backgroundColor = UIColor.footerBackground
    self.backgroundView!.layer.cornerRadius = 10;
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  @objc func buttonTapped() {
    self.delegate?.consentCellTapped(chosenCell: .footer)
  }
  
  override func setup(title t: String, message m: String) {
    super.setup(title: t, message: m)
    footer.defaults = self.defaults
    footer.options = self.options
    footer.delegate = self.delegate
    footer.setup(title: t, message: m)
  }
  
}







class ConsentHeader: ConsentHeaderFooterView {
  
  var title = ConsentTitle()
  
  override init(reuseIdentifier: String?) {
    super.init(reuseIdentifier: reuseIdentifier)
    
    addSubview(title)
    title.autoPinEdgesToSuperviewEdges()
    self.backgroundView = UIView()
    self.backgroundView!.backgroundColor = UIColor.white
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  @objc func buttonTapped() {
    self.delegate?.consentCellTapped(chosenCell: .title)
  }
  
  override func setup(title t: String, message m: String) {
    super.setup(title: t, message: m)
    title.defaults = self.defaults
    title.options = self.options
    title.delegate = self.delegate
    title.setup(title: t, message: m)
  }
  
}






class ConsentFooterCell: ConsentCell {
  
  var title = ConsentFooter()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    addSubview(title)
    title.autoPinEdgesToSuperviewEdges()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override func setup(title t: String, message m: String) {
    super.setup(title: t, message: m)
    title.defaults = self.defaults
    title.options = self.options
    title.delegate = self.delegate
    title.setup(title: t, message: m)
  }
}









/// A view controller that displays privacy policies and lets you chose what of your data can be used for analytics and bug reporting, if any at all.
@objc
public class ConsentViewController: UIViewController {

  /// defines the visual options for this view controller
  @objc public var options: ConsentOptions {
    didSet {
      updateViewConstraints()
    }
  }
  
  /// set this to specify your own localizable keys and/or content or a specific bundle to use
  @objc public var defaults = ConsentDefaults()
  
  /// sets a specific mode on how the consent screen is being displayed
  @objc public var mode: ConsentMode = .automatic
  
  /// sets the delegate
  @objc public var delegate: ConsentScreenDelegate?
  
  /// sets the pre-selected consent option
  @objc public var selectedOption: ConsentOption = .fullReporting

  var cells = [CellTypes]()
  var radios = [DLRadioButton]()
  var tableView = UITableView(frame: .zero, style: .plain)
  
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
    view.addSubview(tableView)
    tableView.autoPinEdgesToSuperviewMargins()
    tableView.delegate = self
    tableView.dataSource = self
    tableView.separatorStyle = .none
    tableView.showsVerticalScrollIndicator = false
    tableView.register(ConsentHeader.self, forHeaderFooterViewReuseIdentifier: CellTypes.title.rawValue)
    tableView.register(ConsentFooter.self, forHeaderFooterViewReuseIdentifier: CellTypes.footer.rawValue)

    tableView.register(ConsentTitleCell.self, forCellReuseIdentifier: CellTypes.title.rawValue)
    tableView.register(ConsentSubtitleCell.self, forCellReuseIdentifier: CellTypes.subTitle.rawValue)
    tableView.register(ConsentFooterCell.self, forCellReuseIdentifier: CellTypes.footer.rawValue)
    tableView.register(ConsentButtonCell.self, forCellReuseIdentifier: CellTypes.fullReporting.rawValue)
    tableView.register(ConsentButtonCell.self, forCellReuseIdentifier: CellTypes.bugReporting.rawValue)
    tableView.register(ConsentButtonCell.self, forCellReuseIdentifier: CellTypes.noReporting.rawValue)
    view.backgroundColor = UIColor.white
    tableView.reloadData()
  }
  
}





extension ConsentViewController: UITableViewDataSource, UITableViewDelegate, ConsentCellDelegate {
 
  internal func internalMode() -> ConsentMode {
    var internalMode = mode
    switch mode {
    case .automatic:
      if UIDevice.current.userInterfaceIdiom == .phone {
        if UIScreen.main.bounds.height < ConsentUIDefaults.minimumHeightForSwitchMode {
          internalMode = .cellsAndHeaderFooters
        }
        else {
          internalMode = .cellsOnly
        }
      }
      else {
        internalMode = .cellsAndHeaderFooters
      }
    default:
      // do nothing
      break
    }
    return internalMode
  }
  
  public func numberOfSections(in tableView: UITableView) -> Int {
    cells.removeAll()
    
    if (internalMode() == .cellsOnly) {
      cells.append(.title)
    }

    cells.append(.subTitle)
    radios.removeAll()
    if options.allowsNoReporting {
      cells.append(.noReporting)
    }
    if options.allowsBugReporting {
      cells.append(.bugReporting)
    }
    if options.allowsDiagnoseReporting {
      cells.append(.fullReporting)
    }
    if (internalMode() == .cellsOnly) {
      cells.append(.footer)
    }
    return 1;
  }
  
  public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return cells.count;
  }
  
  func consentCellTapped(chosenCell: CellTypes) {
    switch chosenCell {
    case .bugReporting:
      self.selectedOption = .bugReporting
    case .fullReporting:
      self.selectedOption = .fullReporting
    case .noReporting:
      self.selectedOption = .noReporting
    case .footer:
      self.delegate?.consentScreenCommited(chosenOption: self.selectedOption)
    default:
      // do nothing
      break
    }
  }
  
  public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    if (internalMode() == .cellsAndHeaderFooters) {
      let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: CellTypes.title.rawValue) as! ConsentHeader
      cell.options = options
      cell.defaults = defaults
      cell.delegate = self
      
      cell.setup(title: "", message: "")
      
      return cell
    }
    else {
      return UIView()
    }
  }
  
  public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    if (internalMode() == .cellsAndHeaderFooters) {
      let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: CellTypes.footer.rawValue) as! ConsentFooter
      cell.options = options
      cell.defaults = defaults
      cell.delegate = self
      
      cell.setup(title: "", message: "")
      radios.forEach { (button) in
        button.otherButtons = radios.filter({ (included) -> Bool in
          included != button
        })
      }
      
      return cell
    }
    else {
      return UIView()
    }
  }
  
  public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension;
  }
  
  public func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
    return 10;
  }
  
  public func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
    return 10;
  }
  
  private func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension;
  }
  
  public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cellType = cells[indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: cellType.rawValue) as! ConsentCell
    cell.options = options
    cell.defaults = defaults
    cell.delegate = self
    cell.selectionStyle = .none
    switch cellType {
    case .fullReporting:
      cell.setup(title: defaults.keyConsentOptionDiagnoseReportingTitle.localized(withBundle: defaults.bundle), message: defaults.keyConsentOptionDiagnoseReportingMessage.localized(withBundle: defaults.bundle))
      if let radioCell = cell as? ConsentButtonCell {
        radios.append(radioCell.button)
        radioCell.button.isSelected = selectedOption == .fullReporting
      }
    case .noReporting:
      cell.setup(title: defaults.keyConsentOptionNoReportingTitle.localized(withBundle: defaults.bundle), message: defaults.keyConsentOptionNoReportingMessage.localized(withBundle: defaults.bundle))
      if let radioCell = cell as? ConsentButtonCell {
        radios.append(radioCell.button)
        radioCell.button.isSelected = selectedOption == .noReporting
      }
    case .bugReporting:
      cell.setup(title: defaults.keyConsentOptionBugReportingTitle.localized(withBundle: defaults.bundle), message: defaults.keyConsentOptionBugReportingMessage.localized(withBundle: defaults.bundle))
      if let radioCell = cell as? ConsentButtonCell {
        radios.append(radioCell.button)
        radioCell.button.isSelected = selectedOption == .bugReporting
      }
    default:
      cell.setup(title: "", message: "")
    }
    
    if indexPath.row == cells.count - 1 {
      radios.forEach { (button) in
        button.otherButtons = radios.filter({ (included) -> Bool in
          included != button
        })
      }
    }
    
    return cell
  }
  
}


extension String {
  
  func localized(withBundle bundle: Bundle? = Bundle.init(for: ConsentViewController.self)) -> String {
    return NSLocalizedString(self, bundle: bundle!, comment: "")
  }
  
}


extension UIColor {
  
  @nonobjc class var darkSkyBlue: UIColor {
    return UIColor(red: 54.0 / 255.0, green: 129.0 / 255.0, blue: 221.0 / 255.0, alpha: 1.0)
  }
  
  @nonobjc class var brownishGrey: UIColor {
    return UIColor(white: 102.0 / 255.0, alpha: 1.0)
  }

  @nonobjc class var footerBackground: UIColor {
    return UIColor(white: 0.97, alpha: 1.0)
  }
}

extension UIFont {
  
  func withTraits(traits: UIFontDescriptor.SymbolicTraits...) -> UIFont {
    if let descriptor = self.fontDescriptor.withSymbolicTraits(UIFontDescriptor.SymbolicTraits(traits)) {
      return UIFont(descriptor: descriptor, size: 0)
    }
    return self
  }
  
  func boldItalic() -> UIFont {
    return withTraits(traits: .traitBold, .traitItalic)
  }
  
}
