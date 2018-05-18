//
//  EntryContentViewController.swift
//  Dream Log
//
//  Created by Jerry Ding on 2018-05-18.
//  Copyright © 2018 Jerry Ding. All rights reserved.
//

import UIKit

protocol EntryContentViewControllerDelegate {
    func entryContentViewControllerDidDisappear(updatedEntry : Entry)
}

class EntryContentViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    
    var delegate : EntryContentViewControllerDelegate?
    var currentEntry : Entry?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = currentEntry?.title
        contentTextView.text = currentEntry?.content
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        currentEntry?.content = contentTextView.text
        delegate?.entryContentViewControllerDidDisappear(updatedEntry: currentEntry!)
    }

}
