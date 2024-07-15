//
//  NowPlayingViewController.swift
//  NowPlayingInMenuBar
//

import AppKit
import SnapKit

class NowPlayingViewController: NSViewController {
    
    private var viewModel: NowPlayingViewModel
    
    private var imageView: NSImageView!
    private var titleLabel: NSLabel!
    private var artistLabel: NSLabel!
    private var albumLabel: NSLabel!
    
    init(viewModel: NowPlayingViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
