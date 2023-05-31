//
//  ViewController.swift
//  JrAkademiProject
//
//  Created by cihad güzel on 29.05.2023.
//
import UIKit

class TabbarBaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // TabBarController oluşturma
        let tabBarController = UITabBarController()

        // Games tabı için ViewController oluşturma
        let gamesViewController = GamesViewController()
        let gamesNavigationController = UINavigationController(rootViewController: gamesViewController)
        gamesNavigationController.tabBarItem = UITabBarItem(title: "Games", image: UIImage(systemName: "gamecontroller"), tag: 0)
        gamesNavigationController.navigationBar.prefersLargeTitles = true

        // Arama çubuğunu oluştur
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        gamesViewController.navigationItem.searchController = searchController


        // Favorites tabı için ViewController oluşturma
        let favoritesViewController = FavoritesViewController()
        let favoritesNavigationController = UINavigationController(rootViewController: favoritesViewController)
        favoritesNavigationController.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(systemName: "star.fill"), tag: 1)
        favoritesNavigationController.navigationBar.prefersLargeTitles = true

        // TabBarController'a ViewControllarları ekleme
        tabBarController.viewControllers = [gamesNavigationController, favoritesNavigationController]

        // TabBarController'ı kök View Controller olarak ayarlama
        self.addChild(tabBarController)
        self.view.addSubview(tabBarController.view)
        tabBarController.didMove(toParent: self)

        // Başlık görünümünü ayarlama
        self.title = "Tab Bar Demo"
    }
}

