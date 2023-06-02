//
//  GamesViewController.swift
//  JrAkademiProject
//
//  Created by cihad güzel on 31.05.2023.
//
import UIKit
import SnapKit
import Carbon

class GamesViewController: UIViewController, GameListViewModelDelegate {

    private let viewModel = GameListViewModel()
    private let tableView = UITableView()

    var isToggled = false {
        didSet { render() }}

    private let renderer = Renderer(
        adapter: UITableViewAdapter(),
        updater: UITableViewUpdater())

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Games" //Set Tab Title
        viewModel.delegate = self
        view.backgroundColor = .white
        renderer.target = tableView

        setupTableView()
        viewModel.fetchGames()
        render()
    }

    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120
        tableView.separatorStyle = .none

        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
     }


    func render() {
        var sections: [Section] = []
        var cellNode: [CellNode] = []

       viewModel.games.forEach { Game in
            cellNode.append(CellNode(id: "hello", GameCell(game: Game)))
        }

        let helloSection = Section(id: "hello", cells: cellNode)
        sections.append(helloSection)
       renderer.render(sections)

    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        isToggled.toggle()
    }

    func gamesFetched() {
           // ViewModel'den gelen verileri kullanarak işlemler yapabilirsiniz

        render()
       }

}
