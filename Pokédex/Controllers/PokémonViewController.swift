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
import AVFoundation

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
    let detail = Detail()
    var results : Results<Favourite>?
    var resultsCache : Results<Detail>?
    var replaced = ""
    
    var player : AVAudioPlayer?
    
    @IBOutlet weak var Sprite: UIImageView!
    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var ID: UILabel!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var btnFavourite: UIButton!
    @IBOutlet weak var lblFlavor: UILabel!
    @IBOutlet weak var loadSpinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadFavourite()
        loadCache()
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
        
        if lblFlavor.text == "" && lblType.text == "" {
            getInfo(url: speciesURL)
            getInfo(url: fetchedURL)
        } else if lblFlavor.text == "" {
            getInfo(url: speciesURL)
        } else if lblType.text == "" {
            getInfo(url: fetchedURL)
        }
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
        saveCache()
    }
    
    func updateSpecies(with json : JSON) {
        for (_, value) in json ["flavor_text_entries"] {
            if value["language"]["name"] == "en" {
                let flavourText = value["flavor_text"].string
                replaced = (flavourText?.replacingOccurrences(of: "\n", with: " "))!
                lblFlavor.text = replaced
                loadSpinner.stopAnimating()
                saveCache()
                break
            }
        }
    }
    
    @IBAction func favouriteClicked(_ sender: UIButton) {
        if isFavourite == false {
            playSound()
        }
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
    
    func saveCache() {
        do {
            try realm.write {
                if detail.id.value == nil {
                    detail.id.value = pokemonId!
                }
                detail.flavour = replaced
                detail.type = type.joined(separator: "/")
                realm.add(detail, update: true)
            }
        } catch {
            print("Error saving content: \(error)")
        }
    }
    
    func loadCache(){
        resultsCache = realm.objects(Detail.self)
        for item in resultsCache! {
            if item.id.value == pokemonId {
                lblFlavor.text = item.flavour
                lblType.text = item.type
            }
        }
    }
    
    func playSound() {
        guard let url = Bundle.main.url(forResource: "favourite", withExtension: "mp3") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            
            guard let player = player else { return }
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
