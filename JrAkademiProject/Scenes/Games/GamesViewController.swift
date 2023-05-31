//
//  GamesViewController.swift
//  JrAkademiProject
//
//  Created by cihad güzel on 31.05.2023.
//
import Carbon
import Alamofire
import UIKit
import SnapKit

class GamesViewController: UIViewController {

    private let viewModel = GameListViewModel()
    private let tableView = UITableView()
    private let searchBar = UISearchBar()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Games"

        setupTableView()
        setupConstraints()
       // setupSearchBar()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(GameCell.self, forCellReuseIdentifier: "GameCell")
        viewModel.getGames { [weak self] in
            self?.tableView.reloadData()
        }
    }

    private func setupSearchBar() {
        // Search Bar oluşturma
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "Search"
        searchBar.delegate = self
        searchBar.showsCancelButton = false

        // Search Bar'ı Navigation Bar'a ekleme
        navigationItem.titleView = searchBar
    }

    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        tableView.rowHeight = 100
        tableView.estimatedRowHeight = 100
    }

    private func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(100)
        }
    }
}

extension GamesViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // let game = viewModel.game(at: indexPath.row)
        // Yapmak istediğiniz işlemi burada gerçekleştirin
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfGames()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: "GameCell", for: indexPath) as! GameCell
        let game = viewModel.game(at: indexPath.row)
        cell.configure(with: game)

        return cell
    }
}

extension GamesViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
           if searchText.count > 3 {
               // Arama işlemlerini gerçekleştir
               print(searchText)
           }
       }
}
