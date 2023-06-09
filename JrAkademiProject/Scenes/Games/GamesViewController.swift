//
//  GamesViewController.swift
//  JrAkademiProject
//
//  Created by cihad güzel on 31.05.2023.
//
import UIKit
import SnapKit
import Carbon
import CoreData

class GamesViewController: UIViewController, GameListViewModelDelegate {

    private let viewModel = GameListViewModel()
    private let tableView = UITableView()
    var searchController = UISearchController(searchResultsController: nil)
    var mySearchText = ""
    var isEmptySearch = false
    var timer: Timer?
    var isTypingAllowed = true

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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        render()
      }

    private func setupTableView() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 136
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: -10, left: 0, bottom: 0, right: 0)

        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        }

    func render() {
        var sections: [Section] = []
        var cellNode: [CellNode] = []

        /// arama yaparken 3 karakterden kuçukse empty cell goster
        if isEmptySearch {
            cellNode.append(CellNode(id: "emptyCell", EmptyComponent(name: "No Game has been Searched.")))
            let helloSection = Section(id: "defaultSection", cells: cellNode)
            sections.append(helloSection)
            renderer.render(sections)
            return
        }

        viewModel.fetchAllIDs()
        /// search Request ise
        if viewModel.isSearchRequest {

            viewModel.gamesSearch.forEach { game in


                var gameCell: GameCellStruct
                /// Gamecell arkaplan rengini clicked durumuna göre değiştir

                if(viewModel.checkId(game.id)) {
                    gameCell = GameCellStruct(game: game, color: UIColor(named: "cellBackground") ?? .clear)

                } else {
                    gameCell = GameCellStruct(game: game, color: UIColor.white)
                }

                gameCell.tapGestureHandler = { [weak self] gameID in
                    /// click Handler
                    self?.viewModel.saveClicked(id: gameID)
                    let detailsViewController = DetailsViewController()
                    detailsViewController.gamesId = String(gameID)
                    self?.navigationController?.pushViewController(detailsViewController, animated: true)
                }
                cellNode.append(CellNode(id: game.id, gameCell))
            }

        } else {
            /// Default Request ise
            print(viewModel.gamesDefault.count,"games search ***********************")
            viewModel.gamesDefault.forEach { game in

                var gameCell: GameCellStruct
                /// Gamecell arkaplan rengini clicked durumuna göre değiştir
                if(viewModel.checkId(game.id)) {
                    gameCell = GameCellStruct(game: game, color: UIColor(named: "cellBackground") ?? .clear)
                }
                else {
                    gameCell = GameCellStruct(game: game, color: UIColor.white)
                }

                print(game.name)

                gameCell.tapGestureHandler = { [weak self] gameID in
                    // click Handler
                    self?.viewModel.saveClicked(id: gameID)
                    let detailsViewController = DetailsViewController()
                    detailsViewController.gamesId = String(gameID)
                    self?.navigationController?.pushViewController(detailsViewController, animated: true)
                }
                cellNode.append(CellNode(id: game.id, gameCell))
            }
            let updateCell = CellNode(id: "loading", LoadingCell())
            cellNode.append(updateCell)
        }

        let helloSection = Section(id: "defaultSection", cells: cellNode)
        sections.append(helloSection)
        renderer.render(sections)
        }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)

        isToggled.toggle()
        }

    /// Delegate Function
    func gamesFetched() {
        render()
        }

    /// sayfanın sonuna kadar kaydırıldıgında ikinci sayfanın istegini baslat
      @objc func veriAlindi(notification: Notification) {

          if let veri = notification.userInfo?["veri"] as? Bool {
              if viewModel.isSearchRequest {
                  viewModel.fetchSearchResult(searchText: mySearchText)
              } else {
                  viewModel.fetchGames()
              }
        }
      }

}



extension GamesViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        viewModel.pageSearch = 0
        viewModel.gamesSearch.removeAll()

        if !isTypingAllowed {
            searchBar.text = searchText

             // SearchRequest
             if( searchText.count > 2 ){

             if let searchText = searchBar.text?.replacingOccurrences(of: " ", with: "%20"){
             mySearchText = searchText
             isEmptySearch = false
             viewModel.fetchSearchResult(searchText: searchText)
                 self.tableView.reloadData()
             }

             } else {
             isEmptySearch = true
             render()
             }
        }
        }
    /// kullanıcı yazı yazarken 0.3 sn aralıkla bekleterek spamlamasını engellemek için
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
         if !isTypingAllowed {
             return false
         }

         isTypingAllowed = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
             self.isTypingAllowed = true
         }
        return true
    }

    /// searchbar cancel butonu
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {

        viewModel.gamesDefault.removeAll()
        viewModel.page = 0
        isEmptySearch = false
        viewModel.fetchGames()
        self.tableView.reloadData()
    }
    }

