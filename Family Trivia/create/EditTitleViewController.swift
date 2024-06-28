//
//  EditTitleViewController.swift
//  Family Trivia
//
//  Created by Chris Voronin on 7/23/18.
//  Copyright © 2018 Chris Voronin. All rights reserved.
//

import UIKit

protocol EditTitleViewControllerDelegate {
    func onTitleChanged(title:String, indexPath:IndexPath)
}

class EditTitleViewController: UIViewController {

    var indexPath:IndexPath!
    var text:String!
    var delegate:EditTitleViewControllerDelegate!
    
    @IBOutlet weak var txtTitle: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtTitle.text = text
    }
    
    @IBAction func onTitleChanged(_ sender: UITextField) {
        self.delegate.onTitleChanged(title: self.txtTitle.text!, indexPath: self.indexPath)
    }

}
