//
//  PokédexViewController.swift
//  Pokédex
//
//  Created by Brandan McDevitt on 26/06/2018.
//  Copyright © 2018 Brandan McDevitt. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import Kingfisher

class Poke_dexViewController: UICollectionViewController {
    
    var pokemonDetails : [Int:String] = [:]
    var pokemonId : [Int]?
    var pokemonName : [String]?
    var pokemonSprite : [String]?
    let reuseIdentifier = "cell"
    var baseURL = "http://pokeapi.co/api/v2/pokemon/"
    
    var storedId : Int = 0
    var storedName : String = ""
    var storedSprite : String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return pokemonId!.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MyCollectionViewCell
        cell.id.text = "#" + String(pokemonId![indexPath.item] + 1)
        cell.name.text = pokemonName![indexPath.item].capitalized
        let url = URL(string: pokemonSprite![indexPath.item])
        cell.sprite.kf.setImage(with: url)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        storedId = pokemonId![indexPath.item]
        storedName = pokemonName![indexPath.item]
        storedSprite = pokemonSprite![indexPath.item]
        performSegue(withIdentifier: "goToStats", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToStats" {
            let destinationVC = segue.destination as! Poke_monViewController
            destinationVC.pokemonId = storedId
            destinationVC.pokemonName = storedName
            destinationVC.pokemonSprite = storedSprite
        }
    }
}
