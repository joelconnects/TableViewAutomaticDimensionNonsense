//
//  ViewController.swift
//  TableViewAutoDimension
//
//  Created by Joel Bell on 8/12/17.
//  Copyright © 2017 CraftedByCrazy. All rights reserved.
//

struct CellModel {
  let title: String
  let body: String
}

struct InformationCard {
  static let TableViewCellReuseID: String = "TableViewCell"
  static let EstimatedTableViewRowHeight: CGFloat = 44
  static let EntryGroupLabelInset: CGFloat = 5
  static let DefaultHeightMargin: CGFloat = 20
  static let TitleToDetailMargin: CGFloat = 5
  static let TableViewHeaderRowHeight: CGFloat = 80
  static let ImageCardHeight: CGFloat = 60
  static let SeparatorLineHeight: CGFloat = 1.5
  static let IconHeight: CGFloat = 20
  static let IconToTextMargin: CGFloat = 10
}

enum InformationCardActionType {
  case phone(model: Int)
  case cardImage
  case consultation
  case support
  case privacy
  case hipaa
}

import UIKit
import SnapKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, TableViewCellDelegate {

  private lazy var testData: [CellModel] = {
    var data = [CellModel]()
    data.append(CellModel(title: "Title1", body: "Body1"))
    data.append(CellModel(title: "Title2", body: "Body2"))
    data.append(CellModel(title: "Title3", body: "Body3"))
    data.append(CellModel(title: "Title4", body: "Body4"))
    return data
  }()
  
  private lazy var testTitles: [String] = {
    return [
      "SECTION TITLE 1",
      "SECTION TITLE 2",
      "SECTION TITLE 3",
      "SECTION TITLE 4"
    ]
  }()
  
  // MARK: - View lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    configureTableView()
    setupViewHierarchy()
    configureConstraints()
  }
  
  // MARK: - Setup view hierarchy
  private func setupViewHierarchy() {
    view.addSubview(tableView)
  }
  
  // MARK: - TableView
  private func configureTableView() {
    tableView.delegate = self
    tableView.dataSource = self
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = InformationCard.EstimatedTableViewRowHeight
    tableView.separatorStyle = .none
    tableView.alwaysBounceVertical = false
    tableView.allowsSelection = false
    tableView.sectionFooterHeight = 0
    tableView.register(TableViewCell.self, forCellReuseIdentifier: InformationCard.TableViewCellReuseID)
  }
  
  // MARK: - Layout
  private func configureConstraints() {
    tableView.snp.makeConstraints { make in
      make.edges.equalTo(view)
    }
  }
  
  // MARK: - Lazy Inits
  private lazy var tableView: UITableView = {
   return UITableView(frame: CGRect.zero, style: .grouped)
  }()
  
  // MARK: - UITableViewDataSource
  func numberOfSections(in tableView: UITableView) -> Int {
    return 4
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return testData.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: InformationCard.TableViewCellReuseID, for: indexPath) as! TableViewCell
    cell.delegate = self
    cell.resetCell()
    
    if indexPath.section == 0 && indexPath.row == 0 {
      cell.addIcon(image: #imageLiteral(resourceName: "doctor"), withText: "This is a sentence about the information contained within your information card")
    } else if indexPath.section == 1 && indexPath.row == 0 {
      cell.addAction(type: .cardImage, text: nil, image: #imageLiteral(resourceName: "CreditCard"))
    } else if indexPath.row == 3 {
      cell.addAction(type: .hipaa, text: "2125551212", image: nil)
    } else {
      cell.addTitle(text: testData[indexPath.row].title)
      cell.addDetail(text: testData[indexPath.row].body)
    }

    if indexPath.row == testData.count - 1 {
      cell.addSeparatorLine()
    }
    
    return cell
  }
  
  // MARK: - UITableViewDelgate
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return InformationCard.TableViewHeaderRowHeight
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let headerView = TableViewSectionHeaderView()
    headerView.headerText = testTitles[section]
    return headerView
  }
  
  // MARK: - TableViewCellDelegate
  func actionTapped(type: InformationCardActionType) {
    switch type {
    case .phone:
      print("phone tapped")
    case .cardImage:
      print("card image tapped")
    case .consultation:
      print("consultation requested")
    case .support:
      print("support requested")
    case .hipaa:
      print("hipaa requested")
    case .privacy:
      print("privacy requested")
    }
  }
}

extension UIFont {
  var height:CGFloat {
    let constraintRect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
    let boundingBox = "Anytext".boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: self], context: nil)
    return boundingBox.height
  }
}

class TableViewSectionHeaderView: UIView {
  
  var headerText: String? {
    didSet {
      label.text = headerText
    }
  }
  private lazy var label: EntryGroupLabel = EntryGroupLabel()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) is not supported")
  }
  
  private func commonInit() {
    addSubview(label)
    configureLayout()
  }
  
  private func configureLayout() {
    label.snp.makeConstraints { make in
      make.left.equalTo(self)
      make.centerY.equalTo(self)
    }
  }
}

class EntryGroupLabel: UILabel {
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) is not supported")
  }
  
  override func drawText(in rect: CGRect) {
    let inset = InformationCard.EntryGroupLabelInset
    let insets = UIEdgeInsets(top: inset, left: 0, bottom: inset, right: 0)
    super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
  }
  
  override var intrinsicContentSize: CGSize {
    let inset = InformationCard.EntryGroupLabelInset
    var intrinsicSuperViewContentSize = super.intrinsicContentSize
    intrinsicSuperViewContentSize.height += (inset * 2)
    intrinsicSuperViewContentSize.width += (inset * 2)
    return intrinsicSuperViewContentSize
  }
  
  private func commonInit() {
    self.numberOfLines = 0
    self.textColor = UIColor.white
    self.textAlignment = .center
    self.layer.cornerRadius = 5
    self.clipsToBounds = true
    self.font = UIFont.systemFont(ofSize: 14)
    self.backgroundColor = UIColor.blue
  }
}


// MARK: - 

class InformationCardTapGesture: UITapGestureRecognizer {
  let type: InformationCardActionType
  init(type: InformationCardActionType) {
    self.type = type
    super.init(target: nil, action: nil)
  }
}

// MARK: - TableViewCell

protocol TableViewCellDelegate: class {
  func actionTapped(type: InformationCardActionType)
}

class TableViewCell: UITableViewCell {
  
  // MARK: TableViewCellDelegate
  weak var delegate: TableViewCellDelegate?
  
  // MARK: - Inits
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    contentView.addSubview(stackView)
    configureConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) is not supported")
  }
  
  private func configureConstraints() {
    stackView.snp.makeConstraints { make in
      make.edges.equalTo(contentView)
    }
  }
  
  // MARK: - Reset cell
  func resetCell() {
    for subview in stackView.arrangedSubviews {
      subview.removeFromSuperview()
    }
  }
  
  // MARK: - Add views
  func addTitle(text: String) {
    stackView.addArrangedSubview(makeTitleLabel(withText: text))
    addSpacerView(withHeight: InformationCard.TitleToDetailMargin)
    
  }
  
  func addDetail(text: String) {
    stackView.addArrangedSubview(makeDetailLabel(withText: text))
    addSpacerView(withHeight: InformationCard.DefaultHeightMargin)
  }
  
  func addSubDetail(text: String) {
    stackView.addArrangedSubview(makeSubDetailLabel(withText: text))
    addSpacerView(withHeight: InformationCard.DefaultHeightMargin)
  }
  
  func addIcon(image: UIImage, withText text: String) {
    configureIcon(image: image, text: text)
  }
  
  func addAction(type: InformationCardActionType, text: String?, image: UIImage?) {
    let tap = InformationCardTapGesture(type: type)
    tap.addTarget(self, action: #selector(TableViewCell.handleTapGesture(_:)))
    
    switch type {
    case .phone:
      guard let text = text else { return }
      let detail = makeDetailLabel(withText: text)
      detail.isUserInteractionEnabled = true
      detail.addGestureRecognizer(tap)
      stackView.addArrangedSubview(detail)
      addSpacerView(withHeight: InformationCard.DefaultHeightMargin)
      
    case .cardImage:
      guard let image = image else { return }
      let imageView = makeImageView(withImage: image, height: InformationCard.ImageCardHeight)
      imageView.isUserInteractionEnabled = true
      imageView.addGestureRecognizer(tap)
      stackView.addArrangedSubview(imageView)
      configureImageView(imageView)
      addSpacerView(withHeight: InformationCard.DefaultHeightMargin)
      
    default:
      guard let text = text else { return }
      let subDetail = makeSubDetailLabel(withText: text)
      subDetail.isUserInteractionEnabled = true
      subDetail.addGestureRecognizer(tap)
      stackView.addArrangedSubview(subDetail)
      addSpacerView(withHeight: InformationCard.DefaultHeightMargin)
    }
  }
  
  func addSeparatorLine() {
    let separatorLine = makeSeparatorLine()
    stackView.addArrangedSubview(separatorLine)
    separatorLine.snp.makeConstraints { make in
      make.width.equalTo(self)
      make.height.equalTo(InformationCard.SeparatorLineHeight)
    }
  }

  private func addSpacerView(withHeight height: CGFloat) {
    let spacerView = UIView()
    stackView.addArrangedSubview(spacerView)
    spacerView.snp.makeConstraints { make in
      make.width.equalTo(self)
      make.height.equalTo(height)
    }
  }
  
  // MARK: - View configuration
  private func configureIcon(image: UIImage, text: String) {
    let container = UIView()
    
    let imageView = UIImageView(image: image)
    let widthMultiplier = image.size.width / image.size.height
    let size = CGSize(width: (InformationCard.IconHeight * widthMultiplier), height: InformationCard.IconHeight)
    imageView.frame = CGRect(origin: imageView.frame.origin, size: size)
    imageView.backgroundColor = UIColor.red
    
    let label = makeDetailLabel(withText: text)
    
    container.addSubview(imageView)
    container.addSubview(label)
    stackView.addArrangedSubview(container)
    
    let labelWidth = self.frame.size.width - imageView.frame.size.width - InformationCard.IconToTextMargin
    let maxSize = CGSize(width: labelWidth, height: CGFloat(FLT_MAX))
    let labelSize = label.text!.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: label.font], context: nil).size
    
    var containerHeight: CGFloat
    let errorMargin: CGFloat = 1
    let textIsTaller: Bool = label.intrinsicContentSize.height > imageView.frame.size.height
    containerHeight = textIsTaller ? labelSize.height : imageView.frame.size.height
    containerHeight += errorMargin
    
    imageView.snp.makeConstraints { make in
      make.left.centerY.equalTo(container)
      make.width.equalTo(imageView.frame.size.width)
      make.height.equalTo(imageView.frame.size.height)
    }
    
    label.snp.makeConstraints { make in
      make.left.equalTo(imageView.snp.right).offset(InformationCard.IconToTextMargin)
      make.right.equalTo(container)
      make.centerY.equalTo(imageView)
      make.height.equalTo(containerHeight)
    }
    
    container.snp.makeConstraints { make in
      make.edges.equalTo(contentView)
      make.height.equalTo(containerHeight + (InformationCard.DefaultHeightMargin * 2)).priority(999)
    }
  }
  
  private func configureImageView(_ imageView: UIImageView) {
    imageView.snp.makeConstraints { make in
      make.width.equalTo(imageView.frame.size.width)
      make.height.equalTo(imageView.frame.size.height).priority(999)
    }
  }
  
  // MARK: - View creation
  private func makeTitleLabel(withText text: String) -> UILabel {
    let label = UILabel()
    label.text = text
    label.textAlignment = .left
    label.numberOfLines = 0
    label.textColor = UIColor.brown
    label.font = UIFont.systemFont(ofSize: 16)
    label.backgroundColor = UIColor.lightGray
    return label
  }
  
  private func makeDetailLabel(withText text: String) -> UILabel {
    let label = UILabel()
    label.text = text
    label.textAlignment = .left
    label.numberOfLines = 0
    label.textColor = UIColor.black
    label.font = UIFont.systemFont(ofSize: 20)
    label.backgroundColor = UIColor.lightGray
    return label
  }
  
  private func makeSubDetailLabel(withText text: String) -> UILabel {
    let label = UILabel()
    label.text = text
    label.textAlignment = .left
    label.numberOfLines = 0
    label.textColor = UIColor.cyan
    label.font = UIFont.systemFont(ofSize: 14)
    label.backgroundColor = UIColor.lightGray
    return label
  }
  
  private func makeImageView(withImage image: UIImage, height: CGFloat) -> UIImageView {
    let widthMultiplier = image.size.width / image.size.height
    let size = CGSize(width: height * widthMultiplier, height: height)
    let imageView = UIImageView()
    imageView.frame = CGRect(origin: CGPoint.zero, size: size)
    imageView.image = image
    imageView.contentMode = .scaleAspectFit
    return imageView
  }
  
  private func makeSeparatorLine() -> UIView {
    let view = UIView()
    view.backgroundColor = UIColor.darkGray
    return view
  }

  // MARK: - Lazy init
  private lazy var stackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.alignment = .leading
    return stackView
  }()
  
  // MARK: - Actions
  @objc
  private func handleTapGesture(_ sender: InformationCardTapGesture) {
    self.delegate?.actionTapped(type: sender.type)
  }
  
}
