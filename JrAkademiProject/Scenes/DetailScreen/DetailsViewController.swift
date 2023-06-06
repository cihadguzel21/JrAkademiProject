//
//  DetailsViewController.swift
//  JrAkademiProject
//
//  Created by cihad güzel on 4.06.2023.
//

import UIKit
import SnapKit
import Carbon

class DetailsViewController: UIViewController, DetailsViewModelDelegate {


    private let viewModel = DetailsViewModel()
    private let tableView = UITableView()
    var gamesId: String = ""

    var isToggled = false {
        didSet { render() }}

    private let renderer = Renderer(
        adapter: UITableViewAdapter(),
        updater: UITableViewUpdater())

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        view.backgroundColor = .white
        renderer.target = tableView

        let favoriteButton = UIBarButtonItem(title: "Favorite", style: .plain, target: self, action: #selector(favoriteButtonTapped))
            navigationItem.rightBarButtonItem = favoriteButton
        setupTableView()
        viewModel.fetchDetails(gameID: gamesId)
    }

    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: -30, left: 0, bottom: 0, right: 0)

        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        }

    func render() {
        var sections: [Section] = []
        var cellNode: [CellNode] = []

        guard let imageUrl = viewModel.gameDetails?.backgroundImageAdditional else { return }
        cellNode.append(CellNode(id: "hello", ImageWithTitleComponent(
            imageUrl: imageUrl, name: viewModel.gameDetails?.name ?? "")))
        cellNode.append(CellNode(id: "hello", DescriptionComponent(
            description: viewModel.gameDetails?.descriptionRaw ?? "")))
        cellNode.append(CellNode(id: "urlReddit", OpenUrlComponent(
            websiteName: "reddit", url: viewModel.gameDetails?.redditURL ?? "https://www.reddit.com/")))
        cellNode.append(CellNode(id: "urlReddit", OpenUrlComponent(
            websiteName: "website", url: viewModel.gameDetails?.website ?? "https://www.reddit.com/")))

        let helloSection = Section(id: "hello", cells: cellNode)
        sections.append(helloSection)
        renderer.render(sections)
        }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        isToggled.toggle()
        }

    // Delegate Function
    func detailsFetched() {
        render()
    }

    @objc private func favoriteButtonTapped() {
       
        // Favoriye ekleme/çıkarma işlemlerini burada yapabilirsiniz

    }
}
