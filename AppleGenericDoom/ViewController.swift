//
//  ViewController.swift
//  AppleGenericDoom
//
//  Created by Tanner W. Stokes on 7/8/23.
//

import Cocoa
import SpriteKit

class ViewController: NSViewController {
    private let viewSize = NSSize(
        width: Int(DOOMGENERIC_RESX),
        height: Int(DOOMGENERIC_RESY)
    )

    private var scene: DoomScene!
    private var node: SKSpriteNode?

    override func viewDidLoad() {
        super.viewDidLoad()
        let skview = SKView(frame: .init(origin: .zero, size: viewSize))
        view.addSubview(skview)

        scene = DoomScene(size: view.bounds.size)
        scene.scaleMode = .resizeFill
        scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        // skview.preferredFramesPerSecond = 30

        skview.presentScene(scene)
        startDoom()
    }

    override func viewWillAppear() {
        super.viewWillAppear()
        preferredContentSize = viewSize
    }


    private func startDoom() {
        DoomGenericSwift.shared().frameDrawCallback = { [weak self] data in
            guard let self else { return }

            let newTexture = SKTexture(data: data, size: self.viewSize, flipped: true)

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

