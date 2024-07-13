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
        
        MRMediaRemoteGetNowPlayingInfo(DispatchQueue.main, { (information) in
            debugPrint("artist: \(information["kMRMediaRemoteNowPlayingInfoArtist"])")
            debugPrint("title: \(information["kMRMediaRemoteNowPlayingInfoTitle"])")
            debugPrint("album: \(information["kMRMediaRemoteNowPlayingInfoAlbum"])")
//                debugPrint("artwork: \(information["kMRMediaRemoteNowPlayingInfoArtworkData"])")
            debugPrint("elapsedTime: \(information["kMRMediaRemoteNowPlayingInfoElapsedTime"])")
            debugPrint("duration: \(information["kMRMediaRemoteNowPlayingInfoDuration"])")
        })
    }
}
