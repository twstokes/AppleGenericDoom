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

        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.red.cgColor
        print(view.frame)
        startDoom()
    }

    private func startDoom() {
        DoomGenericSwift.shared().frameDrawCallback = { buffer in
            print("Frame draw callback fired! Buffer size: \(buffer.count)")
        }

        // start up DOOM
        doomgeneric_Create(0, nil)

//        while true {
            doomgeneric_Tick()
            doomgeneric_Tick()
            doomgeneric_Tick()
            doomgeneric_Tick()
            doomgeneric_Tick()
            doomgeneric_Tick()
//        }
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

