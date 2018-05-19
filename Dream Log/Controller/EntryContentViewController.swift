//
//  EntryContentViewController.swift
//  Dream Log
//
//  Created by Jerry Ding on 2018-05-18.
//  Copyright © 2018 Jerry Ding. All rights reserved.
//

import UIKit

protocol EntryContentViewControllerDelegate {
    func entryContentViewControllerDidSaveData(updatedEntry : Entry)
}

class EntryContentViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    
    var delegate : EntryContentViewControllerDelegate?
    var currentEntry : Entry?
    var timer : Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = currentEntry?.title
        contentTextView.text = currentEntry?.content
        timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(saveData), userInfo: nil, repeats: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        timer!.invalidate()
        saveData()
    }
    
    @objc func saveData() {
        currentEntry?.content = contentTextView.text
        delegate?.entryContentViewControllerDidSaveData(updatedEntry: currentEntry!)
    }

}
