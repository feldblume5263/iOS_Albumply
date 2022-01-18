//
//  PlayerOption.swift
//  Music-Player
//
//  Created by Junhong Park on 2022/01/18.
//

import SwiftUI

enum RepeatMode: CaseIterable {
    case noRepeat // 반복 없음
    case albumRepeat // 앨범 내 전곡 반복
    case oneSongRepeat // 한 곡 반복
}

//MARK: 플레이어의 옵션
struct PlayerOption {
    var repeatMode: RepeatMode = .noRepeat
    var isShuffle: Bool = false
}
