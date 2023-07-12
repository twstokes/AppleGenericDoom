//
//  DoomGeneric_Swift.swift
//  AppleGenericDoom
//
//  Created by Tanner W. Stokes on 7/9/23.
//

import Foundation

@objc class DoomGenericSwift: NSObject {
    private static var sharedDoomGenericSwift: DoomGenericSwift = {
        return DoomGenericSwift()
    }()

    var frameDrawCallback: ((Data) -> Void)?

    @objc func DG_DrawFrame() {
        let data = Data(bytes: DG_ScreenBuffer, count: Int(DOOMGENERIC_RESX) * Int(DOOMGENERIC_RESY) * 4)
        frameDrawCallback?(data)
    }

    // we use a singleton pattern to avoid passing around an instance
    @objc class func shared() -> DoomGenericSwift {
        return sharedDoomGenericSwift
    }
}
