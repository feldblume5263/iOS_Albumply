//
//  ContentView.swift
//  Music-Player
//
//  Created by Junhong Park on 2022/01/12.
//

import SwiftUI
import MediaPlayer

struct ContentView: View {
    
    @State private var player = MPMusicPlayerController.applicationMusicPlayer
    @State var isPlaying = false
    
    var body: some View {
        NavigationView {
            LibraryView(player: $player)
        }
        MiniPlayerView(player: $player)
    }
}
