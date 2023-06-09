//
//  GameDetailsView.swift
//  JrAkademiProject
//
//  Created by cihad güzel on 1.06.2023.
//


import UIKit
import SnapKit
import Kingfisher
import Carbon

class ImageWithTitleComponent: UIView, Component {

    let gameImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 36)
        label.textColor = UIColor.white
        return label
    }()

    init(imageUrl: String, name: String) {
        super.init(frame: .zero)
        setupViews()
        setupConstraints()
        configure(imageUrl: imageUrl, name: name)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
        setupConstraints()
    }

    private func setupViews() {
        addSubview(gameImageView)
        addSubview(titleLabel)
    }

    // MARK: - SetUp Constraints
    private func setupConstraints() {
        gameImageView.snp.makeConstraints {
            $0.top.left.bottom.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(235)
        }

        titleLabel.snp.makeConstraints {
            $0.bottom.equalTo(gameImageView.snp.bottom).inset(16)
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().inset(16)
        }
    }

    func configure(imageUrl: String, name: String) {

        titleLabel.text = name
        if let url = URL(string: imageUrl) {
            gameImageView.kf.setImage(with: url)
        }
    }

    // MARK: - Component
    func render(in content: ImageWithTitleComponent) {
        // Burada herhangi bir işlem yapmanıza gerek yok
    }

    func referenceSize(in bounds: CGRect) -> CGSize? {
        return CGSize(width: bounds.width, height: 251) // Replace 64 with the desired height value
    }

    func renderContent() -> ImageWithTitleComponent {
        return self
    }

}
