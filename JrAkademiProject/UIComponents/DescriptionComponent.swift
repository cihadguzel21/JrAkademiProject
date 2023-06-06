//
//  DescriptionComponent.swift
//  JrAkademiProject
//
//  Created by cihad güzel on 5.06.2023.
//

import UIKit
import SnapKit
import Kingfisher
import Carbon

class DescriptionComponent: UIView, Component {



    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        return label
    }()

    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10 ,weight: .light)
        label.numberOfLines = 0
        return label
    }()

    init(description: String) {
        super.init(frame: .zero)
        setupViews()
        setupConstraints()
        configure(description: description)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
        setupConstraints()
    }

    private func setupViews() {
        addSubview(titleLabel)
        addSubview(descriptionLabel)
    }

    // MARK: - SetUp Constraints
    private func setupConstraints() {

        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().inset(16)
        }

        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().inset(16)
        }
    }

    func configure(description: String) {
        titleLabel.text = "Game Description" // TODO: add localized strings

        let paragraphStyle = NSMutableParagraphStyle()
         paragraphStyle.lineSpacing = 22 - descriptionLabel.font.lineHeight
               let attributedText = NSAttributedString(string: description, attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
               descriptionLabel.attributedText = attributedText
    }

    // MARK: - Component
    func render(in content: DescriptionComponent) {
        // Burada herhangi bir işlem yapmanıza gerek yok
    }

    func referenceSize(in bounds: CGRect) -> CGSize? {
        let width = bounds.width - 32 // Sol ve sağ kenarlardaki boşlukları düşürün
        let titleHeight = titleLabel.sizeThatFits(CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)).height
        let descriptionHeight = descriptionLabel.sizeThatFits(CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)).height
        let height = titleHeight + descriptionHeight + 48 // Başlık ve açıklama arasındaki boşlukları ve üst/alt kenar boşluklarını hesaplayın
        return CGSize(width: width, height: height)
    }


    func renderContent() -> DescriptionComponent {
        return self
    }

}
