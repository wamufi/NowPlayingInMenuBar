//
//  StatusBar.swift
//  NowPlayingInMenuBar
//

import AppKit

class StatusBar: NSObject {
    
    private var statusItem: NSStatusItem!
    private var popover: NSPopover!
    private let viewModel = NowPlayingViewModel()
    private let nowPlayingViewController: NowPlayingViewController
    
    private let bundle = CFBundleCreate(kCFAllocatorDefault, NSURL(fileURLWithPath: "/System/Library/PrivateFrameworks/MediaRemote.framework"))
    
    override init() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        nowPlayingViewController = NowPlayingViewController(viewModel: viewModel)
        
        super.init()
        
        addPopover()
        updateStatusItem()
        
        viewModel.onDataUpdated = { [weak self] in
            self?.updateStatusItem()
            self?.nowPlayingViewController.updateUI()
        }
    }

    private func updateStatusItem() {
        guard let button = statusItem.button else { return }
        button.title = {
            if viewModel.isDataEmpty {
                "No music playing"
            } else {
                viewModel.artist.isEmpty ? "\(viewModel.title)" : "\(viewModel.artist) - \(viewModel.title)"
            }
        }()
        button.target = self
        button.action = #selector(togglePopover)
    }
    
    private func addPopover() {
        popover = NSPopover()
        popover.contentSize = nowPlayingViewController.view.frame.size
        popover.behavior = .transient
        popover.contentViewController = nowPlayingViewController
    }
    
    @objc private func togglePopover() {
        if let button = statusItem.button {
            if popover.isShown {
                popover.performClose(nil)
            } else {
                popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
                popover.contentViewController?.view.window?.makeKey()
            }
        }
    }
}
