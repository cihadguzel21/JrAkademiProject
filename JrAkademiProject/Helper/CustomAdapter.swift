//
//  CustomAdapter.swift
//  JrAkademiProject
//
//  Created by cihad güzel on 6.06.2023.
//

import Carbon

class CustomTableViewAdapter: UITableViewAdapter {


  override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    var isLast = false
    let lastSectionIndex = tableView.numberOfSections - 1
    let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1


    if indexPath.section == lastSectionIndex && indexPath.row == lastRowIndex {
      isLast = true
        print("Son hücre", isLast, lastRowIndex, indexPath.row)
      NotificationCenter.default.post(name: NSNotification.Name("İslemTamamlandi"), object: nil, userInfo: ["veri": isLast])

    }
  }
}



