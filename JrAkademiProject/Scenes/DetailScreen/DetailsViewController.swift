//
//  DetailsViewController.swift
//  JrAkademiProject
//
//  Created by cihad güzel on 4.06.2023.
//

import UIKit
import SnapKit
import Carbon
import CoreData

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

        /// Tıklanan oyun favorilerde varsa butonun textini favorited yap
        guard let name = viewModel.gameDetails?.name else { return }
        let alreadyFavorited = isGameAlreadyFavorited(key: "name", value: name)
         if alreadyFavorited {
           navigationItem.rightBarButtonItem?.title = "Favorited" // UIBarButtonItem'ın title'ını "Ufuk" olarak güncelle
         }
    }

    @objc private func favoriteButtonTapped() {

        /// Data
        guard let id = viewModel.gameDetails?.id else { return }
        guard let name = viewModel.gameDetails?.name else { return }
        guard let metacritic = viewModel.gameDetails?.metacritic else { return }

        guard let imageUrl = viewModel.gameDetails?.backgroundImageAdditional else { return }

        /// context ve AppDelegate tanımla
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let favorite = NSEntityDescription.insertNewObject(forEntityName: "FavoritesDB", into: context)

        /// tablodan data oku, tabloda varsa tekrar kaydetme, kullanıcıya uyarı ver
        if isGameAlreadyFavorited(key: "name", value: name) {
            showAlert(message: "Oyun Favorilerde var!")
            return
        }

        /// Değerleri veritabanına kaydet
        favorite.setValue(id, forKey: "id")
        favorite.setValue(name, forKey: "name")
        favorite.setValue(metacritic, forKey: "metacritic")
        favorite.setValue(imageUrl, forKey: "imageUrl")

        if let genres = viewModel.gameDetails?.genres {
            let genreNames = genres.compactMap { $0.name }

            let genreString = genres.map { $0.name ?? "" }.joined(separator: ", ") as NSString
            favorite.setValue(genreString, forKey: "genre")
        }

        do {
            try context.save()
          navigationItem.rightBarButtonItem?.title = "Favorited" // UIBarButtonItem'ın title'ını güncelle
        } catch let error as NSError {
            print("Favori kaydedilemedi: \(error), \(error.userInfo)")
        }
        }

        private func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
        }

    func isGameAlreadyFavorited(key: String, value: String) -> Bool {
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return false
            }
          let managedContext = appDelegate.persistentContainer.viewContext
          let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoritesDB")
          fetchRequest.predicate = NSPredicate(format: "\(key) == %@", value)
          do {
            let results = try managedContext.fetch(fetchRequest)
            return !results.isEmpty
          } catch { print("Favori Bulunamadı")
              return false
          }
        }
}
