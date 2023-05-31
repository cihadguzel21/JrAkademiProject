//
//  GameCell.swift
//  JrAkademiProject
//
//  Created by cihad güzel on 31.05.2023.
//

import UIKit
import SnapKit
import Kingfisher

class GameCell: UITableViewCell {
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

    let genreLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()

    let ratingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupViews()
        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setupViews()
        setupConstraints()
    }

    private func setupViews() {
        addSubview(gameImageView)
        addSubview(titleLabel)
        addSubview(genreLabel)
        addSubview(ratingLabel)
    }

    private func setupConstraints() {
        gameImageView.snp.makeConstraints { make in
            make.top.left.bottom.equalToSuperview().inset(8)
            make.width.equalTo(120)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.left.equalTo(gameImageView.snp.right).offset(8)
            make.right.equalToSuperview().inset(8)
        }

        genreLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.left.equalTo(titleLabel)
            make.right.equalToSuperview().inset(8)
        }

        ratingLabel.snp.makeConstraints { make in
            make.top.equalTo(genreLabel.snp.bottom).offset(4)
            make.left.equalTo(titleLabel)
            make.right.bottom.equalToSuperview().inset(8)
        }
    }
    func configure(with game: Game) {
            titleLabel.text = game.name
            genreLabel.text = "game.genre"
            ratingLabel.text = "Metacritic Rating: \(game.metacritic)"

            if let url = URL(string: game.background_image) {
                gameImageView.kf.setImage(with: url)
            }
        }
}

