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
                updateValue(with: false)
            } else if sender.isOn == true {
                player?.play()
                updateValue(with: true)
            }
        } else if sender.tag == 2 {
            if !sender.isOn {
                sfx?.stop()
                UserDefaults.standard.set(false, forKey: "sfx")
                
            } else {
                sfx?.play()
                UserDefaults.standard.set(true, forKey: "sfx")
                
            }
        }
    }
    
    func updateValue(with value : Bool) {
        UserDefaults.standard.set(value, forKey: "music")
        musicState = UserDefaults.standard.bool(forKey: "music")
    }
}
