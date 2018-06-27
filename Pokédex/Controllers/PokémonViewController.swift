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

class Poke_monViewController: UIViewController {
    
    var pokemonId : Int?
    var pokemonName : String?
    var pokemonSprite : String?

    var baseURL = "http://pokeapi.co/api/v2/pokemon/"
    var baseSpeciesURL = "http://pokeapi.co/api/v2/pokemon-species/"
    var type : [String] = []
    var favourite = false
    
    @IBOutlet weak var Sprite: UIImageView!
    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var ID: UILabel!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var btnFavourite: UIButton!
    @IBOutlet weak var lblFlavor: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: pokemonSprite!)
        Sprite.kf.setImage(with: url)
        Name.text = pokemonName!.capitalized
        ID.text = "#" + String(pokemonId! + 1)
        let fetchedURL = baseURL + String(pokemonId! + 1)
        let speciesURL = baseSpeciesURL + String(pokemonId! + 1)
        getInfo(url: fetchedURL)
        getInfo(url: speciesURL)
    }
    func getInfo(url : String) {
        Alamofire.request(url, method: .get)
            .responseJSON { response in
                if response.result.isSuccess {
                    print("Connection Successful!")
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
        let flavourText = json["flavor_text_entries"][1]["flavor_text"].string
        let replaced = flavourText?.replacingOccurrences(of: "\n", with: " ")
        lblFlavor.text = replaced
    }
    
    @IBAction func favouriteClicked(_ sender: UIButton) {
        favourite = !favourite
        if favourite == true {
            btnFavourite.setImage(#imageLiteral(resourceName: "star-filled"), for: .normal)
        } else {
            btnFavourite.setImage(#imageLiteral(resourceName: "star-empty"), for: .normal)
        }
    }
}
