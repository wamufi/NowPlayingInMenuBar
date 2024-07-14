//
//  StatusBar.swift
//  NowPlayingInMenuBar
//

import AppKit

class StatusBar: NSObject {
    
    private var statusItem: NSStatusItem!
    private var popover: NSPopover!
    
    private let bundle = CFBundleCreate(kCFAllocatorDefault, NSURL(fileURLWithPath: "/System/Library/PrivateFrameworks/MediaRemote.framework"))
    
    override init() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        super.init()
        
        getNowPlayingInfo()
        loadNowPlaying()
    }
    
    private func loadNowPlaying() {
        let MRMediaRemoteRegisterForNowPlayingNotificationsPointer = CFBundleGetFunctionPointerForName(bundle, "MRMediaRemoteRegisterForNowPlayingNotifications" as CFString)
        typealias MRMediaRemoteRegisterForNowPlayingNotificationsFunction = @convention(c) (DispatchQueue) -> Void
        let MRMediaRemoteRegisterForNowPlayingNotifications = unsafeBitCast(MRMediaRemoteRegisterForNowPlayingNotificationsPointer, to: MRMediaRemoteRegisterForNowPlayingNotificationsFunction.self)
        
        NotificationCenter.default.addObserver(self, selector: #selector(getNowPlayingInfo), name: Notification.Name(rawValue: "kMRMediaRemoteNowPlayingInfoDidChangeNotification"), object: nil)
        MRMediaRemoteRegisterForNowPlayingNotifications(DispatchQueue.main)
    }
    
    @objc private func getNowPlayingInfo() {
        let MRMediaRemoteGetNowPlayingInfoPointer = CFBundleGetFunctionPointerForName(bundle, "MRMediaRemoteGetNowPlayingInfo" as CFString)
        typealias MRMediaRemoteGetNowPlayingInfoFunction = @convention(c) (DispatchQueue, @escaping ([String: Any]) -> Void) -> Void
        let MRMediaRemoteGetNowPlayingInfo = unsafeBitCast(MRMediaRemoteGetNowPlayingInfoPointer, to: MRMediaRemoteGetNowPlayingInfoFunction.self)
        
        MRMediaRemoteGetNowPlayingInfo(DispatchQueue.main, { information in
            if !information.isEmpty {
                self.updateStatusItem(information: information)
            }
        })
    }
    
    private func updateStatusItem(information: [String: Any]) {
        let artist = information["kMRMediaRemoteNowPlayingInfoArtist"] ?? ""
        let title = information["kMRMediaRemoteNowPlayingInfoTitle"] ?? ""
        let album = information["kMRMediaRemoteNowPlayingInfoAlbum"] ?? ""
        let duration = information["kMRMediaRemoteNowPlayingInfoDuration"] ?? ""
        
        guard let button = statusItem.button else { return }
        button.title = "\(artist) - \(title)"
    }
}
