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
        configure(with: game)
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
        gameImageView.snp.makeConstraints {
            $0.top.left.bottom.equalToSuperview().inset(16)
            $0.width.equalTo(120)
            $0.height.equalTo(104)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(gameImageView).offset(16)
            $0.left.equalTo(gameImageView.snp.right).offset(16)
            $0.right.equalToSuperview().inset(16)
        }

        ratingLabel.snp.makeConstraints {
            $0.bottom.equalTo(genreLabel.snp.top)
            $0.left.equalTo(titleLabel)
            $0.right.equalToSuperview().inset(16)
        }

        genreLabel.snp.makeConstraints {
            $0.left.equalTo(titleLabel)
            $0.right.equalToSuperview().inset(16)
            $0.bottom.equalTo(gameImageView).inset(16)
        }

    }

    func configure(with game: Game) {
        titleLabel.text = game.name
        genreLabel.text = "game.genre"
        ratingLabel.attributedText = createColoredText(text: game.metacritic ?? 0)

        guard let imageUrl = game.backgroundImage else { return }
        if let url = URL(string: imageUrl) {
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

  // change color of a part of text
func createColoredText(text: Int) -> NSMutableAttributedString {
    let fullText = "Metacritic Rating: \(text)"
    let attributedString = NSMutableAttributedString(string: fullText)

    let targetText = "\(text)"
    let range = (fullText as NSString).range(of: targetText)
    attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: range)
    attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: 14), range: range)

    return attributedString
}

