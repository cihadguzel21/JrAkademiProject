//
//  CustomFavoriteAdapter.swift
//  JrAkademiProject
//
//  Created by cihad güzel on 8.06.2023.
//
import UIKit
import Carbon
import CoreData

class CustomFavoritesAdapter: UITableViewAdapter {
    weak var favoritiesVC: FavoritesViewController?

    func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            showDeleteConfirmationPopup(forRowAt: indexPath)
        }
    }

    func showDeleteConfirmationPopup(forRowAt indexPath: IndexPath) {
        let alertController = UIAlertController(title: "Silme İşlemi", message: "Silmek istediğinizden emin misiniz?", preferredStyle: .alert)

        let deleteAction = UIAlertAction(title: "Evet", style: .destructive) { [weak self] _ in
            self?.deleteFavoriteItem(at: indexPath)
        }
        alertController.addAction(deleteAction)

        let cancelAction = UIAlertAction(title: "Hayır", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)

        favoritiesVC?.present(alertController, animated: true, completion: nil)
    }

    func deleteFavoriteItem(at indexPath: IndexPath) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedObjectContext: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoritesDB")
        fetchRequest.predicate = NSPredicate(format: "name == %@", favoritiesVC?.favoritesViewModel.gamesFavorites[indexPath.row].name ?? "")

        do {
            let results = try managedObjectContext.fetch(fetchRequest) as! [NSManagedObject]
            if let object = results.first {
                managedObjectContext.delete(object)
                try managedObjectContext.save()
            }
        } catch let error as NSError {
            print("Could not delete data: \(error), \(error.userInfo)")
        }

        favoritiesVC?.favoritesViewModel.fetchLocalGames()
        favoritiesVC?.tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Sil") { [weak self] (action, view, completion) in
            self?.showDeleteConfirmationPopup(forRowAt: indexPath)
            completion(true)
        }

        deleteAction.image = UIImage(systemName: "trash.fill")
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }
}
