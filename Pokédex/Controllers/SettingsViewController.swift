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
    let volume = UserDefaults.standard.float(forKey: "volume")
    var musicState = UserDefaults.standard.bool(forKey: "music")
    var sfxState = UserDefaults.standard.bool(forKey: "sfx")
   
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var musicSwitch: UISwitch!
    @IBOutlet weak var sfxSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        slider.value = volume
        musicSwitch.isOn = musicState
        sfxSwitch.isOn = sfxState
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
                print("sfx: \(sfxState)")
            } else if sender.isOn == true {
                sfx?.play()
                updateValue(with: true, key: "sfx")
                print("sfx: \(sfxState)")
            }
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
}
