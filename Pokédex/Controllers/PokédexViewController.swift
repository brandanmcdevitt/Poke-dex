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
    
    @IBOutlet weak var myLabel: UILabel!
    
    var pokemonDetails : [Int:String] = [:]
    var pokemonId : [Int]?
    var pokemonName : [String]?
    var pokemonSprite : [String]?
    let reuseIdentifier = "cell"
    var baseURL = "http://pokeapi.co/api/v2/pokemon/"

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
        cell.id.text = "#" + String(pokemonId![indexPath.item])
        cell.name.text = pokemonName![indexPath.item]
        
        let url = URL(string: pokemonSprite![indexPath.item])
        // this downloads the image asynchronously if it's not cached yet
        cell.sprite.kf.setImage(with: url)
        cell.backgroundColor = UIColor.lightGray
        
        return cell
    }
    
//    func loadImage(url spriteURL : String) {
//        if let url = NSURL(string: spriteURL) {
//            if let data = NSData(contentsOf: url as URL) {
//                cell.sprite.image = UIImage(data: data as Data)
//            }
//        }
//    }
}
