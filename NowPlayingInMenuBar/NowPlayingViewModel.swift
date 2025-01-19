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
    
    var artwork: NSImage? {
        if let artworkData = self.data["kMRMediaRemoteNowPlayingInfoArtworkData"] as? Data, let image = NSImage(data: artworkData) {
            image
        } else {
//            NSImage()
            nil
        }
    }
    
    var isDataEmpty: Bool {
        self.data.isEmpty ? true : false
    }
}

/*
 // spotify
 ["kMRMediaRemoteNowPlayingInfoContentItemIdentifier": DAA4F8AD-5312-44ED-A23D-BBD759836FEE, "kMRMediaRemoteNowPlayingInfoArtworkIdentifier": 618111A3-D052-46C0-AD86-0ABC3D04B5DF, "kMRMediaRemoteNowPlayingInfoPlaybackRate": 1, "kMRMediaRemoteNowPlayingInfoDuration": 141.05, "kMRMediaRemoteNowPlayingInfoArtworkData": <ffd8ffe0 00104a46 49460001 ... >, "kMRMediaRemoteNowPlayingInfoArtworkDataHeight": 600, "kMRMediaRemoteNowPlayingInfoTotalTrackCount": 1, "kMRMediaRemoteNowPlayingInfoArtist": P!nk, "kMRMediaRemoteNowPlayingInfoArtworkMIMEType": image/jpeg, "kMRMediaRemoteNowPlayingInfoTotalDiscCount": 1, "kMRMediaRemoteNowPlayingInfoTitle": Cover Me In Sunshine, "kMRMediaRemoteNowPlayingInfoArtworkDataWidth": 600, "kMRMediaRemoteNowPlayingInfoDiscNumber": 1, "kMRMediaRemoteNowPlayingInfoTimestamp": 2024-07-15 14:47:41 +0000, "kMRMediaRemoteNowPlayingInfoMediaType": kMRMediaRemoteNowPlayingInfoTypeAudio, "kMRMediaRemoteNowPlayingInfoTrackNumber": 1, "kMRMediaRemoteNowPlayingInfoAlbum": Cover Me In Sunshine, "kMRMediaRemoteNowPlayingInfoElapsedTime": 0]
 
 // librewolf
 ["kMRMediaRemoteNowPlayingInfoAlbum": , "kMRMediaRemoteNowPlayingInfoTimestamp": 2024-07-15 14:51:40 +0000, "kMRMediaRemoteNowPlayingInfoArtist": , "kMRMediaRemoteNowPlayingInfoPlaybackRate": 1, "kMRMediaRemoteNowPlayingInfoContentItemIdentifier": D2EC27D7-F4E1-4E49-AF47-355D3E3D3EE7, "kMRMediaRemoteNowPlayingInfo
 ": LibreWolf is playing media]
 
 // chrome
 ["kMRMediaRemoteNowPlayingInfoTimestamp": 2024-07-15 14:52:56 +0000, "kMRMediaRemoteNowPlayingInfoDuration": 252.161, "kMRMediaRemoteNowPlayingInfoArtist": , "kMRMediaRemoteNowPlayingInfoPlaybackRate": 1, "kMRMediaRemoteNowPlayingInfoArtworkMIMEType": image/jpeg, "kMRMediaRemoteNowPlayingInfoArtworkData": <ffd8ffe0 00104a46 49460001 ... >, "kMRMediaRemoteNowPlayingInfoArtworkIdentifier": D1A9A4DF-7AE1-4000-BC10-D15A3C4D3E4B, "kMRMediaRemoteNowPlayingInfoElapsedTime": 0, "kMRMediaRemoteNowPlayingInfoTitle": A site is playing media, "kMRMediaRemoteNowPlayingInfoContentItemIdentifier": 9480F08A-BF12-4697-8637-E50C8C98BE23, "kMRMediaRemoteNowPlayingInfoArtworkDataHeight": 128, "kMRMediaRemoteNowPlayingInfoAlbum": , "kMRMediaRemoteNowPlayingInfoArtworkDataWidth": 128, "kMRMediaRemoteNowPlayingInfoCurrentPlaybackDate": 2024-07-15 14:46:14 +0000]
 
 // safari
 ["kMRMediaRemoteNowPlayingInfoUniqueIdentifier": 2914918, "kMRMediaRemoteNowPlayingInfoElapsedTime": 0, "kMRMediaRemoteNowPlayingInfoPlaybackRate": 1, "kMRMediaRemoteNowPlayingInfoArtworkDataHeight": 188, "kMRMediaRemoteNowPlayingInfoArtworkData": <4d4d002a 0003db08 111015ff  ... >, "kMRMediaRemoteNowPlayingInfoArtworkIdentifier": 2914918, "kMRMediaRemoteNowPlayingInfoDuration": 252.161, "kMRMediaRemoteNowPlayingInfoContentItemIdentifier": 2914918, "kMRMediaRemoteNowPlayingInfoTimestamp": 2024-07-15 14:54:35 +0000, "kMRMediaRemoteNowPlayingInfoAlbum": , "kMRMediaRemoteNowPlayingInfoArtworkMIMEType": image/jpeg, "kMRMediaRemoteNowPlayingInfoArtworkDataWidth": 336, "kMRMediaRemoteNowPlayingInfoArtist": 乘风2024 Ride the Wind, "kMRMediaRemoteNowPlayingInfoTitle": 【Election·Stage】This Is Me - #chenhaoyu#Nicole#shangwenjie#TIA#Vinida｜Ride The Wind 2024｜MangoTV]
 */
