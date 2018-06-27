//
//  PokémonViewController.swift
//  Pokédex
//
//  Created by Brandan McDevitt on 27/06/2018.
//  Copyright © 2018 Brandan McDevitt. All rights reserved.
//

import UIKit
import Kingfisher

class Poke_monViewController: UIViewController {
    
    var pokemonId : Int?
    var pokemonName : String?
    var pokemonSprite : String?

    @IBOutlet weak var Sprite: UIImageView!
    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var ID: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: pokemonSprite!)
        Sprite.kf.setImage(with: url)
        Name.text = pokemonName!.capitalized
        ID.text = "#" + String(pokemonId! + 1)
    }
}
