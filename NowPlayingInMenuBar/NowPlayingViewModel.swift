//
//  NowPlayingViewModel.swift
//  NowPlayingInMenuBar
//

import AppKit

class NowPlayingViewModel {
    private let bundle = CFBundleCreate(kCFAllocatorDefault, NSURL(fileURLWithPath: "/System/Library/PrivateFrameworks/MediaRemote.framework"))
    private var data: [String: Any] = [:]
    
    var onDataUpdated: (() -> Void)?
    
    init() {
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
                self.data = information
                self.onDataUpdated?()
            } else {
                self.data = [:]
            }
        })
    }
    
    var artist: String {
        self.data["kMRMediaRemoteNowPlayingInfoArtist"] as? String ?? ""
    }
    
    var title: String {
        self.data["kMRMediaRemoteNowPlayingInfoTitle"] as? String ?? ""
    }
    
    var album: String {
        self.data["kMRMediaRemoteNowPlayingInfoAlbum"] as? String ?? ""
    }
    
    var artwork: NSImage {
        if let artworkData = self.data["kMRMediaRemoteNowPlayingInfoArtworkData"] as? Data, let image = NSImage(data: artworkData) {
            image
        } else {
            NSImage()
        }
    }
    
    var isDataEmpty: Bool {
        self.data.isEmpty ? true : false
    }
}

