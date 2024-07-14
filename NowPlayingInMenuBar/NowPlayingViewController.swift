//
//  NowPlayingViewController.swift
//  NowPlayingInMenuBar
//

import AppKit

class NowPlayingViewController: NSViewController {
    
    var information: [String: Any]! {
        didSet {
            debugPrint(information)
//            updateItems()
        }
    }
    
    override func loadView() {
        view = NSView(frame: NSRect(x: 0, y: 0, width: 400, height: 300))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
    }
    
    private func setupLayout() {
        
    }
}
