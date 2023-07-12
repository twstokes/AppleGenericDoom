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

        guard let wadPath = getFirstWadLocation() else {
            print("Failed to find a WAD file!")
            return
        }

        let args = ["foo", "-iwad", wadPath]

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

    // returns the full path of the first file found in the bundled WADs directory
    func getFirstWadLocation() -> String? {
        guard let resourcePath = Bundle.main.resourcePath else {
            return nil
        }

        let fileManager = FileManager.default
        let wadsPath = resourcePath.appending("/WADs")

        guard let firstFileName = try? fileManager.contentsOfDirectory(atPath: wadsPath).first else {
            return nil
        }

        return wadsPath.appending("/" + firstFileName)
    }
}
