//
//  AboutTableViewController.swift
//  Family Trivia
//
//  Created by Chris Voronin on 10/25/21.
//  Copyright © 2021 Chris Voronin. All rights reserved.
//

import UIKit

class AboutTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            let sb = UIStoryboard(name: "Instructions", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "instructions")
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 1 {
            let sb = UIStoryboard(name: "store", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "legal")
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 2 {
            let sb = UIStoryboard(name: "store", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "terms")
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

}
