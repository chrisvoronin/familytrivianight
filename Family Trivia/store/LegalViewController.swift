//
//  LegalViewController.swift
//  Family Trivia
//
//  Created by Chris Voronin on 10/25/21.
//  Copyright © 2021 Chris Voronin. All rights reserved.
//

import UIKit

class LegalViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.isSelectable = true
        textView.isScrollEnabled = true
        let value = NSNumber(integerLiteral: UITouch.TouchType.indirect.rawValue)
        textView.panGestureRecognizer.allowedTouchTypes = [value]
        textView.isUserInteractionEnabled = true
    }
}
