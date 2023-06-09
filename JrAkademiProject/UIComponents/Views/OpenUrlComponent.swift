//
//  GoUrlComponent.swift
//  JrAkademiProject
//
//  Created by cihad güzel on 5.06.2023.
//

import UIKit
import SnapKit
import Kingfisher
import Carbon

class OpenUrlComponent: UIView, Component, UITextViewDelegate {

    let urlTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.isScrollEnabled = false
        return textView
    }()

    init(websiteName: String, url: String) {
        super.init(frame: .zero)
        setupViews()
        setupConstraints()
        configure(websiteName: websiteName, url: url)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
        setupConstraints()
    }

    private func setupViews() {
        addSubview(urlTextView)

        // UITextViewDelegate'i ayarla
        urlTextView.delegate = self
    }

    // MARK: - SetUp Constraints
    private func setupConstraints() {
        urlTextView.snp.makeConstraints {
            $0.top.left.equalToSuperview().offset(16)
            $0.bottom.right.equalToSuperview().inset(16)
        }
    }

    func configure(websiteName: String, url: String) {
        let text = "Visit \(websiteName)"
        let attributedText = NSMutableAttributedString(string: text)

        // Textin tamamını seçili hale getir
        let range = NSRange(location: 0, length: attributedText.length)
        attributedText.addAttribute(.link, value: url, range: range)

        // Özel formatlamalar yapabilirsiniz
        attributedText.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 16), range: range)
       // attributedText.addAttribute(.foregroundColor, value: UIColor(named: "TextColorGrey") ?? UIColor.black, range: range)

        // Attributed text'i textView'a atayın
        urlTextView.attributedText = attributedText

        // URL'yi tıklanabilir hale getir
        urlTextView.isSelectable = true
        urlTextView.isEditable = false
        urlTextView.dataDetectorTypes = .link
        urlTextView.linkTextAttributes = [.foregroundColor: UIColor(named: "TextColorGrey") ?? UIColor.black]
    }



    // MARK: - Component
    func render(in content: OpenUrlComponent) {
    }

    func referenceSize(in bounds: CGRect) -> CGSize? {
           let width = bounds.width - 32 // Sol ve sağ kenarlardaki boşlukları düşürün
           let height = urlTextView.sizeThatFits(CGSize(width: width, height: .greatestFiniteMagnitude)).height
           return CGSize(width: width, height: height + 32) // Toplam yükseklik hesabı için üst ve alt kenar boşluklarını ekleyin
       }

    func renderContent() -> OpenUrlComponent {
        return self
    }

    // MARK: - UITextViewDelegate
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        // URL'yi açmak için Safari'yi başlat
        UIApplication.shared.open(URL, options: [:], completionHandler: nil)
        return false // Tıklamayı işleme devretme
    }

}
