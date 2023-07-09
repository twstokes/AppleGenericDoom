//
//  DoomScene.swift
//  AppleGenericDoom
//
//  Created by Tanner W. Stokes on 7/9/23.
//

import Foundation
import SpriteKit

class DoomScene: SKScene {

    override init(size: CGSize) {
        super.init(size: size)
        doomgeneric_Create(0, nil)
        listdir()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        doomgeneric_Tick()
    }

    func listdir() {
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!

        do {
            let items = try fm.contentsOfDirectory(atPath: path)
            print(path)
            print(fm.currentDirectoryPath)

            for item in items {
                print("Found \(item)")
            }
        } catch {
            // failed to read directory – bad permissions, perhaps?
        }
    }
}
