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
        scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)

        DoomGenericSwift.shared().frameDrawCallback = { data in
            let newTexture = SKTexture(data: data, size: .init(width: Int(DOOMGENERIC_RESX), height: Int(DOOMGENERIC_RESY)), flipped: true)

            let primaryNode = scene.children.first as? SKSpriteNode

            if let primaryNode {
                primaryNode.texture = newTexture
            } else {
                let node = SKSpriteNode(texture: newTexture)
                node.texture = newTexture
                let ratio = Int(DOOMGENERIC_RESX) / Int(DOOMGENERIC_RESY)
                let width = size.width
                node.size = .init(width: width, height: width * CGFloat(ratio))
                scene.addChild(node)
            }
        }

        return scene
    }

    var body: some View {
        SpriteView(scene: doomScene)
            .ignoresSafeArea()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
