//
//  ViewController.swift
//  AppleGenericDoom
//
//  Created by Tanner W. Stokes on 7/8/23.
//

import Cocoa

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // start up DOOM
        doomgeneric_Create(0, nil)

        while true {
            doomgeneric_Tick()
        }
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

