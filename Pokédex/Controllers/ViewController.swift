//
//  ViewController.swift
//  Pokédex
//
//  Created by Brandan McDevitt on 26/06/2018.
//  Copyright © 2018 Brandan McDevitt. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {
    
    let baseURL = "http://pokeapi.co/api/v2/pokemon/?limit=151"
    var pokemonSpriteBase = "http://pokeapi.co/media/sprites/pokemon/"
    var format = ".png"
    var pokemonId : [Int] = []
    var pokemonName : [String] = []
    var pokemonSprite : [String] = []
    var pokemonDetails : [(key: Int, value: String)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getPokemon(url: baseURL)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToPokedex" {
            let destinationVC = segue.destination as! Poke_dexViewController
            destinationVC.pokemonId = pokemonId
            destinationVC.pokemonName = pokemonName
            destinationVC.pokemonSprite = pokemonSprite
        }
    }
    func getPokemon(url : String) {
        Alamofire.request(url, method: .get)
            .responseJSON { response in
                if response.result.isSuccess {
                    print("Connection Successful!")
                    let pokemonJSON : JSON = JSON(response.result.value!)
                    //update ui elements when data is pulled
                    self.updateStats(json: pokemonJSON)
                } else {
                    print("Error: \(String(describing: response.result.error))")
                }
        }
    }
    
    func updateStats(json : JSON) {
        var results : [Int:String] = [:]
        for i in 0..<151 {
            let id = json["results"][i]["name"].string
            results[i] = id
        }
        pokemonDetails = results.sorted(by: <)
        for (key, value) in pokemonDetails {
            pokemonId.append(key)
            pokemonName.append(value)
            pokemonSprite.append(pokemonSpriteBase + String(key + 1) + format)
        }
    }
}

