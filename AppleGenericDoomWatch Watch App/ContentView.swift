//
//  ContentView.swift
//  AppleGenericDoomWatch Watch App
//
//  Created by Tanner W. Stokes on 7/9/23.
//

import SwiftUI
import SpriteKit

struct ContentView: View {
    var doomScene: DoomScene {
        let size = WKInterfaceDevice.current().screenBounds.size
        let scene = DoomScene(size: size)

        DoomGenericSwift.shared().frameDrawCallback = { data in
            let newTexture = SKTexture(data: data, size: .init(width: Int(DOOMGENERIC_RESX), height: Int(DOOMGENERIC_RESY)), flipped: true)
            scene.doomNode.texture = newTexture
        }

        return scene
    }

    var body: some View {
        SpriteView(scene: doomScene)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
