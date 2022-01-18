//
//  PlayerOption.swift
//  Music-Player
//
//  Created by Junhong Park on 2022/01/18.
//

import SwiftUI

enum RepeatMode: CaseIterable {
    case noRepeat
    case albumRepeat
    case oneSongRepeat
}

struct PlayerOption {
    var repeatMode: RepeatMode = .noRepeat
    var isShuffle: Bool = false
}
