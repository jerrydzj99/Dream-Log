//
//  EntryContentViewController.swift
//  Dream Log
//
//  Created by Jerry Ding on 2018-05-18.
//  Copyright © 2018 Jerry Ding. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class EntryContentViewController: UIViewController {
    
    @IBOutlet weak var contentTextView: UITextView!
    
    let realm = try! Realm()
    
    var currentEntry : Entry?
    var timer : Timer?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.backgroundColor = GradientColor(.topToBottom, frame: view.frame, colors: [FlatPlum(),FlatSkyBlue()])
        contentTextView.text = currentEntry!.content
        timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(updateData), userInfo: nil, repeats: true)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        guard let navView = navigationController?.view else { fatalError("navigation view not found") }
        navView.backgroundColor = GradientColor(.topToBottom, frame: navView.frame, colors: [FlatPlum(),FlatSkyBlue()])
        
        title = currentEntry!.title
        
        contentTextView.textColor = ContrastColorOf(navView.backgroundColor!, returnFlat: true)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        timer!.invalidate()
        updateData()
    }
    
    @objc func updateData() {
        
        do {
            try realm.write {
                currentEntry!.content = contentTextView.text
            }
        } catch {
            print("error updating data \(error)")
        }
        
    }

}
