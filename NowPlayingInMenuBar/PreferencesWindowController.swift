//
//  PreferencesWindowController.swift
//  NowPlayingInMenuBar
//

import AppKit
import ServiceManagement
import SnapKit

class PreferencesWindowController: NSWindowController {
    
    private var launchAtLogin: Bool = SMAppService.mainApp.status == .enabled
    private let stackView = {
        let view = NSStackView()
        view.orientation = .vertical
        view.alignment = .leading
        view.edgeInsets = NSEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        view.distribution = .fillProportionally
        view.spacing = 8
        return view
    }()
    
    convenience init() {
        self.init(window: NSWindow(contentRect: NSRect(x: 0, y: 0, width: 400, height: 300), styleMask: [.titled, .closable], backing: .buffered, defer: false))
        
        window?.center()
        window?.title = "Preferences"
        window?.delegate = self
        
        setupLayout()
    }
    
    private func setupLayout() {
        guard let view = window?.contentView else { return }
        view.addSubview(stackView)
        
        let launchCheckbox = NSButton(checkboxWithTitle: "Launch at Login", target: self, action: #selector(launchCheckboxTapped(sender:)))
        launchCheckbox.state = launchAtLogin ? .on : .off
        stackView.addArrangedSubview(launchCheckbox)
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalTo(view.safeAreaLayoutGuide)
            make.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.width.equalTo(400)
        }
        
    }
    
    func show() {
        NSApp.activate()
        window?.makeKeyAndOrderFront(nil)
        
        NSApp.setActivationPolicy(.regular)
    }
    
    @IBAction func launchCheckboxTapped(sender: NSButton) {
        do {
            if sender.state == .on {
                try SMAppService.mainApp.register()
            } else {
                try SMAppService.mainApp.unregister()
            }
        } catch {
//            logError(items: error.localizedDescription)
        }
        
        launchAtLogin = SMAppService.mainApp.status == .enabled
    }
}

extension PreferencesWindowController: NSWindowDelegate {
    func windowWillClose(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)
    }
}
