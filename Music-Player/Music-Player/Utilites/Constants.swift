//
//  Constants.swift
//  Music-Player
//
//  Created by Junhong Park on 2022/01/13.
//

import SwiftUI
import MediaPlayer

// String
let undefinedString: String = "Undefined"


// Font
let libraryAlbumTitleFont = Font.system(size: 15, weight: .semibold)
let libraryAlbumArtistFont = Font.system(size: 13, weight: .regular)


// Color
let libraryAlbumTitleFontColor = Color.black
let libraryAlbumArtistFontColor = Color.secondary

// to print playback state
extension MPMusicPlaybackState {
    func printState() {
        print(self)
        switch self {
        case .interrupted:
            print("interrupted")
        case .stopped:
            print("stopped")
        case .playing:
            print("playing")
        case .paused:
            print("paused")
        case .seekingForward:
            print("seekingForward")
        case .seekingBackward:
            print("seekingBackward")
        @unknown default:
            break
        }
    }
}

extension CaseIterable where Self: Equatable, AllCases: BidirectionalCollection {
    func previous() -> Self {
        let all = Self.allCases
        guard let idx = all.firstIndex(of: self) else { return self }
        let previous = all.index(before: idx)
        return all[previous < all.startIndex ? all.index(before: all.endIndex) : previous]
    }

    func next() -> Self {
        let all = Self.allCases
        guard let idx = all.firstIndex(of: self) else { return self }
        let next = all.index(after: idx)
        return all[next == all.endIndex ? all.startIndex : next]
    }
}

