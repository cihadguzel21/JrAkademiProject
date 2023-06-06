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
    var searchController = UISearchController(searchResultsController: nil)

    var isToggled = false {
        didSet { render() }}

    private let renderer = Renderer(
        adapter: CustomTableViewAdapter(),
        updater: UITableViewUpdater()
      )

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Games" // Set Tab Title
        viewModel.delegate = self
        view.backgroundColor = .white
        renderer.target = tableView

        // Arama çubuğunu oluştur
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.delegate = self

        NotificationCenter.default.addObserver(self, selector: #selector(veriAlindi(notification:)), name: NSNotification.Name("İslemTamamlandi"), object: nil)

        setupTableView()
        viewModel.fetchGames()
    }

    private func setupTableView() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120
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

        viewModel.games.forEach { game in

            var gameCell = GameCellStruct(game: game)
            print(game.name)

            gameCell.tapGestureHandler = { [weak self] gameID in
                // click Handler
                let detailsViewController = DetailsViewController()
                detailsViewController.gamesId = String(gameID)
                self?.navigationController?.pushViewController(detailsViewController, animated: true)
            }
            cellNode.append(CellNode(id: "defaultCell", gameCell))
        }
        print("********************************+ \(cellNode.count)")

        let updateCell = CellNode(id: "loading", LoadingCell())
                 cellNode.append(updateCell)

        let helloSection = Section(id: "defaultSection", cells: cellNode)
        sections.append(helloSection)
        renderer.render(sections)
        }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)

        isToggled.toggle()
        }

    // Delegate Function
    func gamesFetched() {
        render()
        }

    // Veriyi alma fonksiyonu
      @objc func veriAlindi(notification: Notification) {
        if let veri = notification.userInfo?["veri"] as? Bool {
          // Veriyi kullan
          // Örneğin, başka bir view controller'ı açmak ve veriyi göndermek:
            print("notification \(veri)")
            viewModel.fetchGames()
        }
      }
}

extension GamesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if searchText.count > 3 {
            // SearchRequest
            viewModel.fetchSearchResult(searchText: searchText)
        } else {
            // gamesViewController.fetchGames()
        }
    }
}
