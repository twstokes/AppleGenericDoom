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

    var frameDrawCallback: (([uint32]) -> Void)?

    override init() {
        super.init()
        print("Swift DG_Init called")
    }

    @objc func DG_DrawFrame() {
        print("Swift DG_DrawFrame called")
        let buffer = Array(UnsafeBufferPointer(start: DG_ScreenBuffer, count: Int(DOOMGENERIC_RESX) * Int(DOOMGENERIC_RESY) * 4))
        frameDrawCallback?(buffer)
    }

    // we use a singleton pattern to avoid passing around an instance
    @objc class func shared() -> DoomGenericSwift {
        return sharedDoomGenericSwift
    }
}
