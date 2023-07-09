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

    override init() {
        super.init()
        print("Swift DG_Init called")
    }

    @objc func DG_DrawFrame() {
        print("Swift DG_DrawFrame called")
        // reach into DG_Screenbuffer here? other option is to pass in from ObjC
        let buffer = DG_ScreenBuffer
    }

    // we use a singleton pattern to avoid passing around an instance
    @objc class func shared() -> DoomGenericSwift {
        return sharedDoomGenericSwift
    }
}
