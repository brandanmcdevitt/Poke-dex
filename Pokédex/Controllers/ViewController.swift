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
    var backgroundImageName = ""
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        getPokemon(url: baseURL)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //TODO: fix iphone8 background not loading
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
        switch UIScreen.main.bounds.height {
        case 812:   // 5.8" (iPhone X) (3x) (Portrait)
            backgroundImageName = "bg_iphoneX"
        case 736:  // 5.5" (iPhone 8+, 7+, 6s+, 6+) (3x) (Portrait)
            backgroundImageName = "background_1242x2208"
        case 414:  // 5.5" (iPhone 8+, 7+, 6s+, 6+) (3x) (Landscape)
            backgroundImageName = "bg_iphone8"
        case 667:  // 4.7" (iPhone 8, 7, 6s, 6) (2x) (Portrait)
            backgroundImageName = "background_750x1334"
        default:
            break;
        }
        backgroundImageView.image = #imageLiteral(resourceName: "bg_iphone8")
        //backgroundImageView.image = UIImage(named: backgroundImageName)
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
        } else if segue.identifier == "goToFavourites" {
            let destinationVC = segue.destination as! FavouriteViewController
            destinationVC.pokemonName = pokemonName
            destinationVC.pokemonSprite = pokemonSprite
        }
    }
    func getPokemon(url : String) {
        Alamofire.request(url, method: .get)
            .responseJSON { response in
                if response.result.isSuccess {
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

