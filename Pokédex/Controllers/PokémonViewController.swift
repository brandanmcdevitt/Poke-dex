//
//  PokémonViewController.swift
//  Pokédex
//
//  Created by Brandan McDevitt on 27/06/2018.
//  Copyright © 2018 Brandan McDevitt. All rights reserved.
//

import UIKit
import Kingfisher
import Alamofire
import SwiftyJSON
import RealmSwift

class Poke_monViewController: UIViewController {
    
    let realm = try! Realm()
    
    var pokemonId : Int?
    var pokemonName : String?
    var pokemonSprite : String?

    var baseURL = "http://pokeapi.co/api/v2/pokemon/"
    var baseSpeciesURL = "http://pokeapi.co/api/v2/pokemon-species/"
    var type : [String] = []
    var isFavourite = false
    let favourite = Favourite()
    var results : Results<Favourite>?
    
    @IBOutlet weak var Sprite: UIImageView!
    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var ID: UILabel!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var btnFavourite: UIButton!
    @IBOutlet weak var lblFlavor: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadFavourite()
        if isFavourite == true {
            btnFavourite.setImage(#imageLiteral(resourceName: "star-filled"), for: .normal)
        } else {
            btnFavourite.setImage(#imageLiteral(resourceName: "star-empty"), for: .normal)
        }
        
        let url = URL(string: pokemonSprite!)
        Sprite.kf.setImage(with: url)
        Name.text = pokemonName!.capitalized
        ID.text = "#" + String(pokemonId! + 1)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let fetchedURL = baseURL + String(pokemonId! + 1)
        let speciesURL = baseSpeciesURL + String(pokemonId! + 1)
        getInfo(url: fetchedURL)
        getInfo(url: speciesURL)
    }
    
    func getInfo(url : String) {
        Alamofire.request(url, method: .get)
            .responseJSON { response in
                if response.result.isSuccess {
                    let detailsJSON : JSON = JSON(response.result.value!)
                    //update ui elements when data is pulled
                    if url.contains("pokemon-species") {
                        self.updateSpecies(with: detailsJSON)
                    } else {
                        self.updateDetails(with: detailsJSON)
                    }
                    
                } else {
                    print("Error: \(String(describing: response.result.error))")
                }
        }
    }
    
    func updateDetails(with json : JSON) {
        for(_, value) in json["types"] {
            let types = value["type"]["name"].string?.capitalized
            type.append(types!)
        }
        lblType.text = type.joined(separator: "/")
    }
    
    func updateSpecies(with json : JSON) {
        let flavourText = json["flavor_text_entries"][33]["flavor_text"].string
        let replaced = flavourText?.replacingOccurrences(of: "\n", with: " ")
        lblFlavor.text = replaced
    }
    
    @IBAction func favouriteClicked(_ sender: UIButton) {
        isFavourite = !isFavourite
        saveFavourite()
    }
    
    func saveFavourite() {
        do {
            try realm.write {
                if favourite.id.value == nil {
                    favourite.id.value = pokemonId!
                }
                favourite.isStarred = isFavourite
                realm.add(favourite, update: true)
                if isFavourite == true {
                    btnFavourite.setImage(#imageLiteral(resourceName: "star-filled"), for: .normal)
                } else {
                    btnFavourite.setImage(#imageLiteral(resourceName: "star-empty"), for: .normal)
                }
            }
        } catch {
            print("Error saving content: \(error)")
        }
    }
    
    func loadFavourite(){
        results = realm.objects(Favourite.self)
        for item in results! {
            if item.id.value == pokemonId {
                isFavourite = item.isStarred
        }
    }
    }
    
}
