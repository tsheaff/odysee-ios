//
//  VideoPlayerManager.swift
//  Odysee
//
//  Created by Tyler Sheaffer on 9/23/21.
//

import AVFoundation
import Foundation
import Player
import UIKit

// This class exposes a minimal abstract interface for playing back a video in the app.
// The implementation details (e.g. the use of the Player library) are private.
class VideoPlayerManager {
    static let shared = VideoPlayerManager()

    @UserDefaultsBacked(key: "VideoPlayerManager_playbackRate", defaultValue: 1.0)
    private(set) var playbackRate: Float

    // Please avoid exposing the underlying Player itself. If new behavior is needed,
    // extend the interface of this class or add a new notification from the Player delegate methods.
    private var player: Player

    init() {
        player = Player()

        player.playerDelegate = self
        player.playbackDelegate = self

        player.playerView.playerBackgroundColor = .red
    }

    public func playWithURL(_ url: URL) {
        player.url = url
        player.playFromBeginning()
        setAudioSessionActive()
    }

    public func play() {
        player.playFromCurrentTime()
        setAudioSessionActive()
    }

    public func pause() {
        player.pause()
    }

    public func stop() {
        player.stop()
    }

    public var playerLayer: AVPlayerLayer? {
        return self.player.playerLayer()
    }

    public var isCurrentlyActive: Bool {
        return player.playbackState == .playing || player.playbackState == .paused
    }

    public func addPlayerView(to viewController: UIViewController) -> UIView {
        player.view.frame = viewController.view.bounds

        viewController.addChild(player)
        viewController.view.addSubview(player.view)
        player.didMove(toParent: viewController)
        return player.view
    }

    private func setAudioSessionActive() {
        do {
            try AVAudioSession.sharedInstance().setActive(true, options: [])
        } catch {
            print("AVAudioSession activation failed! \(error)")
        }
    }
}

extension VideoPlayerManager: PlayerDelegate {
    func playerReady(_ player: Player) {
        // TODO: Player Refactor: Trigger notification?
    }

    func playerBufferingStateDidChange(_ player: Player) {
        // TODO: Player Refactor: Trigger notification
        // Previous logic:

//        if keyPath == "timeControlStatus", player!.timeControlStatus == .playing {
//            if currentFileViewController != nil {
//                currentFileViewController!.checkTimeToStart()
//            }
//            return
//        }
//
//        if let player = player,
//           let item = player.currentItem,
//           keyPath == "playbackLikelyToKeepUp",
//           item.isPlaybackLikelyToKeepUp,
//           currentFileViewController?.playerConnected != true,
//           player.timeControlStatus != .paused
//        {
//            player.play()
//        }
    }

    // no-op default implementations (the Player library didn't do this for us)
    func playerPlaybackStateDidChange(_ player: Player) {}
    func playerBufferTimeDidChange(_ bufferTime: Double) {}
    func player(_ player: Player, didFailWithError error: Error?) {}
}

extension VideoPlayerManager: PlayerPlaybackDelegate {
    func playerPlaybackDidEnd(_ player: Player) {
        // TODO: Player Refactor: Trigger notification
        // Previous logic:

//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        appDelegate.currentFileViewController?.playNextPlaylistItem()
    }

    // no-op default implementations (the Player library didn't do this for us)
    func playerCurrentTimeDidChange(_ player: Player) {}
    func playerPlaybackWillStartFromBeginning(_ player: Player) {}
    func playerPlaybackWillLoop(_ player: Player) {}
    func playerPlaybackDidLoop(_ player: Player) {}
}
