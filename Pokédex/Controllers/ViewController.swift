//
//  ViewController.swift
//  Pokédex
//
//  Created by Brandan McDevitt on 26/06/2018.
//  Copyright © 2018 Brandan McDevitt. All rights reserved.
//

//importing frameworks
import UIKit
import Alamofire
import SwiftyJSON
import AVFoundation

class ViewController: UIViewController {
    
    //declaring variables
    let baseURL = "http://pokeapi.co/api/v2/pokemon/?limit=151"
    var pokemonSpriteBase = "http://pokeapi.co/media/sprites/pokemon/"
    var format = ".png"
    var pokemonId : [Int] = []
    var pokemonName : [String] = []
    var pokemonSprite : [String] = []
    var pokemonDetails : [(key: Int, value: String)] = []
    var backgroundImageName = ""
    let themeChoice = ["red", "gold", "ruby", "16bit"]
    var audioPlayers = [AVAudioPlayer?]()
    
    var musicState = UserDefaults.standard.bool(forKey: "music")
    var sfxState = UserDefaults.standard.bool(forKey: "sfx")
    var theme = UserDefaults.standard.string(forKey: "theme")
    
    var player : AVAudioPlayer?
    var sfx : AVAudioPlayer?
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        getPokemon(url: baseURL)
        UserDefaults.standard.set("red", forKey: "theme")
        if theme != nil {
            playSound()
            switch theme {
            case "red":
                player = audioPlayers[0]
                break
            case "gold":
                player = audioPlayers[1]
                break
            case "ruby":
                player = audioPlayers[2]
                break
            case "16bit":
                player = audioPlayers[3]
                break
            default:
                break
            }
        }
        playSoundOnSelect()
        if musicState == true {
            player?.play()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //TODO: fix iphone8 background not loading
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
        switch UIScreen.main.bounds.height {
        case 812:   // 5.8" (iPhone X) (3x) (Portrait)
            backgroundImageName = "X_bg"
        case 736:  // 5.5" (iPhone 8+, 7+, 6s+, 6+) (3x) (Portrait)
            backgroundImageName = "8plus_bg"
        case 667:  // 4.7" (iPhone 8, 7, 6s, 6) (2x) (Portrait)
            backgroundImageName = "8_bg"
        default:
            break;
        }
        //backgroundImageView.image = #imageLiteral(resourceName: "bg_iphone8")
        backgroundImageView.image = UIImage(named: backgroundImageName)
        sfxState = UserDefaults.standard.bool(forKey: "sfx")
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if sfxState == true {
            sfx?.play()
        }
        if segue.identifier == "goToPokedex" {
            let destinationVC = segue.destination as! Poke_dexViewController
            destinationVC.pokemonId = pokemonId
            destinationVC.pokemonName = pokemonName
            destinationVC.pokemonSprite = pokemonSprite
        } else if segue.identifier == "goToFavourites" {
            let destinationVC = segue.destination as! FavouriteViewController
            destinationVC.pokemonName = pokemonName
            destinationVC.pokemonSprite = pokemonSprite
        } else if segue.identifier == "goToSettings" {
            let destinationVC = segue.destination as! SettingsViewController
            destinationVC.player = player
            destinationVC.sfx = sfx
            destinationVC.audioPlayers = audioPlayers
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
    
    func playSound() {
        
        for sound in themeChoice {
            guard let url = Bundle.main.url(forResource: sound, withExtension: "mp3") else { return }
            
            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
                try AVAudioSession.sharedInstance().setActive(true)
                player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
                audioPlayers.append(player)
                
                guard let player = player else { return }
                player.numberOfLoops = -1
                let volume = UserDefaults.standard.float(forKey: "volume")
                player.volume = volume
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    func playSoundOnSelect() {
        guard let url = Bundle.main.url(forResource: "select", withExtension: "wav") else { return }

        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)

            sfx = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.wav.rawValue)

            guard let sfx = sfx else { return }
            let volume = UserDefaults.standard.float(forKey: "volume")
            sfx.volume = volume
            //sfx.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
}

