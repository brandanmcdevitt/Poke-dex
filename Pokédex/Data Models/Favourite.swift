//
//  Favourite.swift
//  Pokédex
//
//  Created by Brandan McDevitt on 27/06/2018.
//  Copyright © 2018 Brandan McDevitt. All rights reserved.
//

import Foundation
import RealmSwift

class Favourite: Object {
    let id = RealmOptional<Int>()
    @objc dynamic var isStarred = false
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
