//
//  FavoritesViewController.swift
//  JrAkademiProject
//
//  Created by cihad güzel on 31.05.2023.
//
import UIKit
import SnapKit
import Carbon

class FavoritesViewController: UIViewController, FavoritesViewModelDelegate {

    var fromSearch = false
    var favoritesViewModel: FavoritesViewModel = FavoritesViewModel()
    private let tableView = UITableView()
    private let cellIdentifier = "Cell"

    private let renderer = Renderer(
    adapter: CustomFavoritesAdapter(),
    updater: UITableViewUpdater()
    )

    override func viewDidLoad() {
    super.viewDidLoad()
    favoritesViewModel.delegate = self
    navigationController?.delegate = self
    renderer.adapter.favoritiesVC = self

    title = "Favorites"
    tableView.contentInset.top = 0
    tableView.separatorStyle = .none
    renderer.target = tableView
    setupUI()
  }


    func render() {
        var sections: [Section] = []
        var cellNode: [CellNode] = []

        favoritesViewModel.gamesFavorites.forEach { game in

            var gameCell = GameCellStruct(game: game)

            gameCell.tapGestureHandler = { [weak self] gameID in
                // click Handler
                let detailsViewController = DetailsViewController()
                detailsViewController.gamesId = String(gameID)
                self?.navigationController?.pushViewController(detailsViewController, animated: true)
            }
            cellNode.append(CellNode(id: "defaultCell", gameCell))

        }

        let helloSection = Section(id: "defaultSection", cells: cellNode)
        sections.append(helloSection)
        renderer.render(sections)
        }

  private func setupUI() {
    view.addSubview(tableView)
    tableView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    tableView.backgroundColor = UIColor(red: 0xF8/255, green: 0xF8/255, blue: 0xF8/255, alpha: 1.0)
  }

    // Delegate Function
    func gamesFetched() {
        render()
        }
}

extension FavoritesViewController: UINavigationControllerDelegate {

    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
      var isFirstAppearance = true
      if isFirstAppearance && viewController is FavoritesViewController {
            isFirstAppearance = false
          favoritesViewModel.gamesFavorites.removeAll()
          favoritesViewModel.fetchLocalGames()
          }
    }
}
