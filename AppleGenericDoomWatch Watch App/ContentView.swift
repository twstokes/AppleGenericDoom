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
        let scene = DoomScene(size: .init(width: 640, height: 400))
        scene.scaleMode = .fill
        return scene
    }

    var body: some View {
        SpriteView(scene: doomScene)
            .frame(width: 640, height: 400)
            .ignoresSafeArea()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
