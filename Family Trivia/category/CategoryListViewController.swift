//
//  FirstViewController.swift
//  Family Trivia
//
//  Created by Chris Voronin on 7/14/18.
//  Copyright © 2018 Chris Voronin. All rights reserved.
//

import UIKit

class CategoryListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CategoryRowCollectionDelegate {

    static func create(title:String, cats:[Int]) -> CategoryListViewController {
        let sb = UIStoryboard(name: "Category", bundle: nil)
        let vc = sb.instantiateInitialViewController() as! CategoryListViewController
        vc.initialCategories = cats
        vc.title = title
        return vc
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    var initialCategories:[Int] = []
    
    var categories:[SearchCategory] = []
    var dataSources:[CategoryRowCollectionDataSource] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let localCategories = TriviaDataController.shared.getCategoriesWithGames()
        
        for categoryId in initialCategories {
            if let category = localCategories.first(where: { $0.categoryId == categoryId }) {
                categories.append(category)
                let ds = CategoryRowCollectionDataSource(data: category.games, delegate:self)
                self.dataSources.append(ds)
            }
        }
        
        let nib = UINib(nibName: "CategoryRowTableViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "cell")
        
    }
    
    //MARK: delegate callback
    
    func onCategorySelected(board: Board) {
        
        let isPremium = board.flags == Board.flagPremium
        
        if !isPremium {
            runGame(board: board)
            return
        }
        
        if IAPHandler.shared.hasPurchasedSubscription {
            runGame(board: board)
        } else {
            let sb = UIStoryboard(name: "store", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "store") as! StoreViewController
            vc.board = board
            vc.delegate = self
            let nav = UINavigationController(rootViewController: vc)
            self.present(nav, animated: true, completion: nil)
        }
    }
    
    private func runGame(board:Board) {
        let vc = ChoosePlayersViewController.createNew(board)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: table view delegate
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return categories[section].title
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CategoryRowTableViewCell
        
        let dataSource = dataSources[indexPath.section]
        let nib = UINib(nibName: "CategoryCollectionViewCell", bundle: nil)
        cell.collectionView.register(nib, forCellWithReuseIdentifier: CategoryCollectionViewCell.reuseIdentifier)
        cell.collectionView.dataSource = dataSource
        cell.collectionView.delegate = dataSource
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view:UIView, forSection: Int) {
        if let tableViewHeaderFooterView = view as? UITableViewHeaderFooterView {
            tableViewHeaderFooterView.textLabel?.textColor = UIColor.white
        }
    }
}

extension CategoryListViewController: StoreViewControllerDelegate {
    
    func onPurchaseControllerFinished(board: Board) {
        if IAPHandler.shared.hasPurchasedSubscription {
            runGame(board: board)
        }
    }
}
