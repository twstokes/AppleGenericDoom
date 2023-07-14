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

    override func viewDidLoad() {
        super.viewDidLoad()
        let skview = SKView(frame: .init(origin: .zero, size: viewSize))
        view.addSubview(skview)
        scene = DoomScene(size: view.bounds.size)
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
            scene.doomNode.texture = newTexture
        }
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

