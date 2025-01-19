//
//  PreferencesWindowController.swift
//  NowPlayingInMenuBar
//

import AppKit
import ServiceManagement
import SnapKit

class PreferencesWindowController: NSWindowController {
    
    private var launchAtLogin: Bool = SMAppService.mainApp.status == .enabled {
        didSet {
            print("launchAtLogin: \(launchAtLogin)")
        }
    }
    private let stackView = {
        let view = NSStackView()
        view.orientation = .vertical
        view.alignment = .leading
        view.edgeInsets = NSEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        view.distribution = .fillProportionally
        view.spacing = 8
        return view
    }()
    
//    convenience init() {
//        self.init(window: NSWindow(contentRect: NSRect(x: 0, y: 0, width: 400, height: 300), styleMask: [.titled, .closable], backing: .buffered, defer: false))
//        
//        window?.center()
//        window?.title = "Preferences"
//        window?.delegate = self
//        
//        setupLayout()
//    }
    
    override init(window: NSWindow?) {
        super.init(window: nil)
        
        let window = NSWindow(contentRect: NSRect(x: 0, y: 0, width: 400, height: 300), styleMask: [.titled, .closable], backing: .buffered, defer: false)
        window.title = "Preferences"
        self.window = window
        
        print("asdf 000")
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadWindow() {
        super.loadWindow()
        
        print("asdf 222")
    }
    
    private func setupLayout() {
        guard let view = window?.contentView else { return }
        view.addSubview(stackView)
        
        let launchCheckbox = NSButton(checkboxWithTitle: "Launch at Login", target: self, action: #selector(launchCheckboxTapped(sender:)))
        launchCheckbox.state = launchAtLogin ? .on : .off
        print("asdf launchAtLogin 333: \(launchAtLogin)")
//        stackView.addArrangedSubview(launchCheckbox)
        view.addSubview(launchCheckbox)
        
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
    
    @objc private func launchCheckboxTapped(sender: NSButton) {
        print("asdf sender: \(sender)")
        do {
            if sender.state == .on {
                try SMAppService.mainApp.register()
            } else {
                try SMAppService.mainApp.unregister()
            }
        } catch {
            print(error.localizedDescription)
        }
        
        print("asdf SMAppService: \(SMAppService.mainApp.status)")
        launchAtLogin = SMAppService.mainApp.status == .enabled
    }
}

extension PreferencesWindowController: NSWindowDelegate {
    func windowWillClose(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)
    }
}
