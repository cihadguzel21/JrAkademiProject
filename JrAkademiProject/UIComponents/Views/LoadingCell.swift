//
//  LoadingCell.swift
//  JrAkademiProject
//
//  Created by cihad güzel on 6.06.2023.
//
import UIKit
import Carbon
import SnapKit

class LoadingCell: UITableViewCell, Component {
  private let activityIndicatorView: UIActivityIndicatorView = {
    let activityIndicatorView = UIActivityIndicatorView(style: .gray)
    activityIndicatorView.startAnimating()
    return activityIndicatorView
  }()
  private let nameLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 13)
    label.textColor = UIColor(red: 0.54, green: 0.54, blue: 0.56, alpha: 1.0)
    label.numberOfLines = 0
    label.lineBreakMode = .byWordWrapping
    label.textAlignment = .center
    return label
  }()
  private var isLoading: Bool = true {
    didSet {
      updateUI()
    }
  }
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupUI()
  }
  override func prepareForReuse() {
    super.prepareForReuse()
    nameLabel.text = nil
  }
  private func setupUI() {
    contentView.addSubview(nameLabel)
    contentView.addSubview(activityIndicatorView)
    nameLabel.snp.makeConstraints { make in
      make.centerX.equalTo(contentView)
      make.leading.trailing.equalTo(contentView).inset(8)
      make.bottom.equalTo(contentView).inset(8)
    }
    activityIndicatorView.snp.makeConstraints { make in
      make.center.equalTo(contentView)
    }
    updateUI()
  }
  private func updateUI() {
    if isLoading {
      nameLabel.text = "Yükleniyor"
      activityIndicatorView.startAnimating()
    } else {
      nameLabel.text = nil
      activityIndicatorView.stopAnimating()
    }
  }
  func startLoading() {
    isLoading = true
  }
  func stopLoading() {
    isLoading = false
  }
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  func render(in content: LoadingCell) {
    // Burada herhangi bir işlem yapmanıza gerek yok
  }
  func referenceSize(in bounds: CGRect) -> CGSize? {
    return CGSize(width: bounds.width, height: 60)
  }
  func renderContent() -> LoadingCell {
    return self
  }
}
