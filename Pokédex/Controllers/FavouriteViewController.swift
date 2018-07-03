//
//  FavouriteViewController.swift
//  Pokédex
//
//  Created by Brandan McDevitt on 28/06/2018.
//  Copyright © 2018 Brandan McDevitt. All rights reserved.
//

import UIKit
import Kingfisher
import RealmSwift

class FavouriteViewController: UICollectionViewController {
    
    let reuseIdentifier = "cell"
    let realm = try! Realm()
    var results : Results<Favourite>?
    var pokemonId : [Int] = []
    var isFavourite = false
    
    var pokemonName : [String]?
    var pokemonSprite : [String]?
    
    var storedId : Int = 0
    var storedName : String = ""
    var storedSprite : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadFavourite()
        let bgImage = UIImageView();
        bgImage.image = UIImage(named: "dexBg");
        bgImage.contentMode = .scaleToFill
        
        self.collectionView?.backgroundView = bgImage
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        print(pokemonId.count)
        return pokemonId.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MyCollectionViewCell
    
        cell.id.text = "#" + String(pokemonId[indexPath.item] + 1)
        let currentPoke = pokemonId[indexPath.item]
        let url = URL(string: pokemonSprite![currentPoke])
        cell.sprite.kf.setImage(with: url)
        cell.name.text = pokemonName?[currentPoke].capitalized
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        storedId = pokemonId[indexPath.item]
        let i = pokemonId[indexPath.item]
        storedName = pokemonName![i]
        storedSprite = pokemonSprite![i]
        performSegue(withIdentifier: "goToStats", sender: self)
    }
    
    func loadFavourite(){
        results = realm.objects(Favourite.self)
        for item in results! {
            if item.isStarred == true {
                pokemonId.append(item.id.value!)
            }
        }
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
