//
//  ContentView.swift
//  AppleGenericDoomWatch Watch App
//
//  Created by Tanner W. Stokes on 7/9/23.
//

import SwiftUI
import SpriteKit

struct ContentView: View {
//    private var scene: DoomScene!
//    private var node: SKSpriteNode?

    var doomScene: DoomScene {
        let scene = DoomScene(size: .init(width: 640, height: 400))
        scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        scene.scaleMode = .resizeFill
        return scene
    }

    var body: some View {
        SpriteView(scene: doomScene)
            .frame(width: 640, height: 400)
            .ignoresSafeArea()
            .onAppear {
                DoomGenericSwift.shared().frameDrawCallback = { data in
                    let newTexture = SKTexture(data: data, size: .init(width: Int(DOOMGENERIC_RESX), height: Int(DOOMGENERIC_RESY)), flipped: true)

                    let primaryNode = doomScene.children.first as? SKSpriteNode

                    if let primaryNode {
                        primaryNode.texture = newTexture
                    } else {
                        let node = SKSpriteNode(texture: newTexture)
                        node.texture = newTexture
                        doomScene.addChild(node)
                    }
                }
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
