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

class GameCell: UITableViewCell {

    var tapGestureHandler: ((Int) -> Void)?
    var gameID: Int?

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


    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
      }
      required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
      }

    private func setupViews() {
        addSubview(gameImageView)
        addSubview(titleLabel)
        addSubview(ratingLabel)
        addSubview(genreLabel)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        addGestureRecognizer(tapGesture)
        isUserInteractionEnabled = true
    }

    // MARK: - SetUp Constraints
    private func setupConstraints() {
        gameImageView.snp.makeConstraints {
            $0.top.left.equalToSuperview().offset(16)
            $0.width.equalTo(120)
            $0.height.equalTo(104)
            $0.bottom.equalToSuperview().inset(16)
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

    // MARK: Handle click
    @objc private func handleTapGesture() {
        tapGestureHandler?(gameID ?? 00)
    }

}

struct GameCellStruct: Component {
  let game: Game
    var tapGestureHandler: ((Int) -> Void)?

  func renderContent() -> GameCell {
    return GameCell(style: .default, reuseIdentifier: "GameTableViewCell")
  }
  func genreToString(array: [String]) -> String {
    return array.joined(separator: ", ")
  }
  func render(in content: GameCell) {
      content.titleLabel.text = game.name
      content.genreLabel.text = "game.genre"
      content.ratingLabel.attributedText = createColoredText(text: game.metacritic ?? 0)

      guard let imageUrl = game.backgroundImage else { return }
      if let url = URL(string: imageUrl) {
          let myProcessor = DownsamplingImageProcessor(size: CGSize(width: 120, height: 104))
          content.gameImageView.kf.setImage(with: url ,options: [.processor(myProcessor)])
      }
      content.gameID = game.id
      content.tapGestureHandler = tapGestureHandler
  }

  func referenceSize(in bounds: CGRect) -> CGSize? {
    return CGSize(width: bounds.width, height: 136)
  }
  func shouldContentUpdate(with next: GameCellStruct) -> Bool {
    return false
  }

    /// change color of a part of text
    func createColoredText(text: Int) -> NSMutableAttributedString {
        let fullText = "Metacritic Rating: \(text)"
        let attributedString = NSMutableAttributedString(string: fullText)

        let targetText = "\(text)"
        let range = (fullText as NSString).range(of: targetText)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: range)
        attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: 14), range: range)

        return attributedString
    }
}

