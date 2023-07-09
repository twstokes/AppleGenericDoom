//
//  ViewController.swift
//  AppleGenericDoom
//
//  Created by Tanner W. Stokes on 7/8/23.
//

import Cocoa
import SpriteKit

class ViewController: NSViewController {
    private var scene: DoomScene!
    private var node: SKSpriteNode?

    override func viewDidLoad() {
        super.viewDidLoad()
        let skview = SKView(frame: .init(origin: .zero, size: .init(width: Int(DOOMGENERIC_RESX), height: Int(DOOMGENERIC_RESY))))
        view.addSubview(skview)

        scene = DoomScene(size: view.bounds.size)
        scene.scaleMode = .resizeFill
        scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)

        skview.presentScene(scene)
        startDoom()
    }

    override func viewWillAppear() {
        super.viewWillAppear()
        preferredContentSize = NSSize(width: Int(DOOMGENERIC_RESX), height: Int(DOOMGENERIC_RESY))
    }


    private func startDoom() {
        DoomGenericSwift.shared().frameDrawCallback = { data in
            let newTexture = SKTexture(data: data, size: .init(width: Int(DOOMGENERIC_RESX), height: Int(DOOMGENERIC_RESY)), flipped: true)

            if let node = self.node {
                node.texture = newTexture
            } else {
                let node = SKSpriteNode(texture: newTexture)
                node.texture = newTexture
                self.scene.addChild(node)
                self.node = node
            }
        }
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

