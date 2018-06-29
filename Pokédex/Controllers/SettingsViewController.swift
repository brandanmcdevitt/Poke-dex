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
    let volume = UserDefaults.standard.float(forKey: "volume")
   
    @IBOutlet weak var slider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        slider.value = volume
    }
    
    @IBAction func volumeSlider(_ sender: UISlider) {
        player?.volume = sender.value
        UserDefaults.standard.set(sender.value, forKey: "volume")
    }

}
