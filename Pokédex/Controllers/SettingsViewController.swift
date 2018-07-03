//
//  SettingsViewController.swift
//  Pokédex
//
//  Created by Brandan McDevitt on 29/06/2018.
//  Copyright © 2018 Brandan McDevitt. All rights reserved.
//

import UIKit
import AVFoundation

class SettingsViewController: UIViewController {

    var player : AVAudioPlayer?
    var sfx : AVAudioPlayer?
    var audioPlayers : [AVAudioPlayer?]?
    let volume = UserDefaults.standard.float(forKey: "volume")
    var musicState = UserDefaults.standard.bool(forKey: "music")
    var sfxState = UserDefaults.standard.bool(forKey: "sfx")
    var theme = UserDefaults.standard.string(forKey: "theme")
    
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var musicSwitch: UISwitch!
    @IBOutlet weak var sfxSwitch: UISwitch!
    @IBOutlet weak var kantoButton: UIButton!
    @IBOutlet weak var johtoButton: UIButton!
    @IBOutlet weak var hoennButton: UIButton!
    @IBOutlet weak var bitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        slider.value = volume
        musicSwitch.isOn = musicState
        sfxSwitch.isOn = sfxState
        addBorder(sender: kantoButton)
        addBorder(sender: johtoButton)
        addBorder(sender: hoennButton)
        addBorder(sender: bitButton)
        
        switch theme {
        case "red":
            buttonSelected(sender: kantoButton)
            break
        case "gold":
            buttonSelected(sender: johtoButton)
            break
        case "ruby":
            buttonSelected(sender: hoennButton)
            break
        case "16bit":
            buttonSelected(sender: bitButton)
            break
        default:
            break
        }
    }
    
    @IBAction func volumeSlider(_ sender: UISlider) {
        player?.volume = sender.value
        UserDefaults.standard.set(sender.value, forKey: "volume")
    }

    @IBAction func AudioStateChanged(_ sender: UISwitch) {
        
        if sender.tag == 1 {
            if !sender.isOn {
                player?.stop()
                updateValue(with: false, key: "music")
            } else if sender.isOn == true {
                player?.play()
                updateValue(with: true, key: "music")
            }
        } else if sender.tag == 2 {
            if !sender.isOn {
                sfx?.stop()
                updateValue(with: false, key: "sfx")
            } else if sender.isOn == true {
                sfx?.play()
                updateValue(with: true, key: "sfx")
            }
        }
    }
    
    @IBAction func ThemeSelected(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            if UserDefaults.standard.string(forKey: "theme") != "red" {
                buttonSelected(sender: sender)
                UserDefaults.standard.set("red", forKey: "theme")
                buttonDeselected(sender: johtoButton)
                buttonDeselected(sender: hoennButton)
                buttonDeselected(sender: bitButton)
                changeTheme(with: sender)
            }
            break
        case 1:
            if UserDefaults.standard.string(forKey: "theme") != "gold" {
                buttonSelected(sender: sender)
                UserDefaults.standard.set("gold", forKey: "theme")
                buttonDeselected(sender: kantoButton)
                buttonDeselected(sender: hoennButton)
                buttonDeselected(sender: bitButton)
                changeTheme(with: sender)
            }
            break
        case 2:
            if UserDefaults.standard.string(forKey: "theme") != "ruby" {
                buttonSelected(sender: sender)
                UserDefaults.standard.set("ruby", forKey: "theme")
                buttonDeselected(sender: kantoButton)
                buttonDeselected(sender: johtoButton)
                buttonDeselected(sender: bitButton)
                changeTheme(with: sender)
            }
            break
        case 3:
            if UserDefaults.standard.string(forKey: "theme") != "16bit" {
                buttonSelected(sender: sender)
                UserDefaults.standard.set("16bit", forKey: "theme")
                buttonDeselected(sender: kantoButton)
                buttonDeselected(sender: johtoButton)
                buttonDeselected(sender: hoennButton)
                changeTheme(with: sender)
            }
            break
        default:
            break
        }
    }
    
    func updateValue(with value : Bool, key : String) {
        UserDefaults.standard.set(value, forKey: key)
        if key == "music" {
        musicState = UserDefaults.standard.bool(forKey: key)
        } else if key == "sfx" {
            sfxState = UserDefaults.standard.bool(forKey: key)
        }
    }
    
    func buttonSelected(sender : UIButton) {
        sender.backgroundColor = UIColor(red:0.83, green:0.18, blue:0.18, alpha:1.0)
        sender.setTitleColor(UIColor(red:0.96, green:0.96, blue:0.96, alpha:1.0), for: .normal)
    }
    
    func buttonDeselected(sender : UIButton) {
        sender.backgroundColor = UIColor(red:0.96, green:0.96, blue:0.96, alpha:1.0)
        sender.setTitleColor(UIColor(red:0.20, green:0.20, blue:0.20, alpha:1.0), for: .normal)
    }
    
    func addBorder(sender : UIButton) {
        sender.layer.cornerRadius = 5
        sender.layer.borderWidth = 1
        sender.layer.borderColor = (UIColor(red:0.20, green:0.20, blue:0.20, alpha:1.0).cgColor)
    }
    
    func changeTheme(with sender : UIButton) {
        if player?.isPlaying == true {
            player?.stop()
            player = audioPlayers?[sender.tag]
            player?.play()
        } else {
            player = audioPlayers?[sender.tag]
        }
    }
}
