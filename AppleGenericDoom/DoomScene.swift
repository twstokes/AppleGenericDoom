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

        let iwadLocation = getiWadLocation()
        let args = ["foo", "-iwad", iwadLocation]

        // h/t https://stackoverflow.com/a/29469618
        var cargs = args.map { strdup($0) }
        doomgeneric_Create(Int32(args.count), &cargs)
        // free the duplicated strings
        for ptr in cargs { free(ptr) }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        doomgeneric_Tick()
    }

    func getiWadLocation() -> String {
        return Bundle.main.resourcePath!.appending("/doom1.wad")
    }
}
