//
//  CustomFavoriteAdapter.swift
//  JrAkademiProject
//
//  Created by cihad güzel on 8.06.2023.
//

import UIKit
import Carbon
import CoreData

class CustomFavoritesAdapter: UITableViewAdapter{

    weak var favoritiesVC: FavoritesViewController?

    func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        // Implement your logic here
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //tableView.deleteRows(at: [indexPath], with: .fade)
            // Delete the corresponding data from Core Data
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            let managedObjectContext: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoritesDB")
            fetchRequest.predicate = NSPredicate(format: "name == %@", favoritiesVC?.favoritesViewModel.gamesFavorites[indexPath.row].name ?? "")
           // print(favoritiesVC?.gamesFavorites[indexPath.row].id)
            do {
                let results = try managedObjectContext.fetch(fetchRequest) as! [NSManagedObject]
                if let object = results.first {
                    managedObjectContext.delete(object)
                    try managedObjectContext.save()
                }
            } catch let error as NSError {
                print("Could not delete data: \(error), \(error.userInfo)")
            }
            // Delete the row from the table view
            favoritiesVC?.favoritesViewModel.fetchLocalGames()
            // tableView.reloadData() // Update the table view after deletion
        }
    }
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Sil") { [weak self] (action, view, completion) in
            // Perform your delete action here
            self?.tableView(tableView, commit: .delete, forRowAt: indexPath)
            completion(true)
        }
        deleteAction.image = UIImage(systemName: "trash.fill")
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }
}
