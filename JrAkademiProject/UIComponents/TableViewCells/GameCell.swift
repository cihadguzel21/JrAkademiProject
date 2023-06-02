//
//  GameCell.swift
//  JrAkademiProject
//
//  Created by cihad güzel on 31.05.2023.
//

import UIKit
import SnapKit
import Kingfisher
import Carbon

class GameCell: UIView, Component {

    let gameImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()

    let ratingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    let genreLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor(named: "customGray")
        return label
    }()

    init(game: Game) {
        super.init(frame: .zero)
        setupViews()
        setupConstraints()
        configure(with:game)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
        setupConstraints()
    }

    private func setupViews() {
        addSubview(gameImageView)
        addSubview(titleLabel)
        addSubview(ratingLabel)
        addSubview(genreLabel)
    }

    // MARK: - SetUp Constraints
    private func setupConstraints() {
        gameImageView.snp.makeConstraints { make in
            make.top.left.bottom.equalToSuperview().inset(16)
            make.width.equalTo(120)
            make.height.equalTo(104)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(gameImageView).offset(16)
            make.left.equalTo(gameImageView.snp.right).offset(16)
            make.right.equalToSuperview().inset(16)
        }

        ratingLabel.snp.makeConstraints { make in
            make.bottom.equalTo(genreLabel.snp.top)
            make.left.equalTo(titleLabel)
            make.right.equalToSuperview().inset(16)
        }

        genreLabel.snp.makeConstraints { make in
            make.left.equalTo(titleLabel)
            make.right.equalToSuperview().inset(16)
            make.bottom.equalTo(gameImageView).inset(16)
        }

    }

    func configure(with game: Game) {
        titleLabel.text = game.name
        genreLabel.text = "game.genre"
        ratingLabel.attributedText = createColoredText(text: game.metacritic)

        if let url = URL(string: game.backgroundImage) {
            gameImageView.kf.setImage(with: url)
        }
        }

    // MARK: - Component
    func render(in content: GameCell) {
        // Burada herhangi bir işlem yapmanıza gerek yok
    }

    func referenceSize(in bounds: CGRect) -> CGSize? {
        return CGSize(width: bounds.width, height: 100) // Replace 64 with the desired height value
    }

    func renderContent() -> GameCell {
        return self
    }
}

  //change color of a part of text
func createColoredText(text: Int) -> NSMutableAttributedString {
    let fullText = "Metacritic Rating: \(text)"
    let attributedString = NSMutableAttributedString(string: fullText)

    let targetText = "\(text)"
    let range = (fullText as NSString).range(of: targetText)
    attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: range)
    attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: 14), range: range)

    return attributedString
}


