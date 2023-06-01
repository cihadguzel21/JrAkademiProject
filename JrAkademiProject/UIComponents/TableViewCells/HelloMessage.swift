//
//  HelloMessage.swift
//  JrAkademiProject
//
//  Created by cihad güzel on 1.06.2023.
//


import UIKit

import SnapKit

import Carbon



class HelloMessage: UIView, Component {

    private let nameLabel = UILabel()
    private let surnameLabel = UILabel()

    init(name: String, surname: String) {
        super.init(frame: .zero)
        setupUI()
        configure(with: name, surname: surname)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - SetUp Constraints
    private func setupUI() {
        addSubview(nameLabel)
        addSubview(surnameLabel)

        nameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-10) // Yeni label'ı önceki label'in üstüne konumlandırma
        }

        surnameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(10) // Yeni label'ı önceki label'in altına konumlandırma
        }
    }

    private func configure(with name: String, surname: String) {
        nameLabel.text = "Hello, \(name)!"
        nameLabel.textColor = .black
        surnameLabel.text = "Surname: \(surname)"
        surnameLabel.textColor = .black
    }


    // MARK: - Render
    func render(in content: HelloMessage) {}

    func referenceSize(in bounds: CGRect) -> CGSize? {
        return CGSize(width: bounds.width, height: 64) // Replace 64 with the desired height value
    }

    func renderContent() -> HelloMessage {
        return self
    }
}
