//
//  Entry.swift
//  Dream Log
//
//  Created by Jerry Ding on 2018-05-22.
//  Copyright © 2018 Jerry Ding. All rights reserved.
//

import Foundation
import RealmSwift

class Entry: Object {
    
    @objc dynamic var title : String = ""
    @objc dynamic var time : Date?
    @objc dynamic var content : String = ""
    
}
