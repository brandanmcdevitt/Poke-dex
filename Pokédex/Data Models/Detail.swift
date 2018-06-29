//
//  Detail.swift
//  Pokédex
//
//  Created by Brandan McDevitt on 29/06/2018.
//  Copyright © 2018 Brandan McDevitt. All rights reserved.
//

import Foundation
import RealmSwift

class Detail : Object {
    let id = RealmOptional<Int>()
    @objc dynamic var flavour : String?
    @objc dynamic var type : String?
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
