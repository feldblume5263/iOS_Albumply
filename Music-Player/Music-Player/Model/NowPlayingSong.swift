//
//  NowPlayingSong.swift
//  Music-Player
//
//  Created by Junhong Park on 2022/01/16.
//

import SwiftUI

// 현재 재생/재생대기 중에 있는 음악의 정보
struct NowPlayingSong {
    var title: String
    var albumTitle: String
    var artist: String
    var artWork: UIImage
    var totalRate: Double // 노래 길이 (playbackDuration)
}
