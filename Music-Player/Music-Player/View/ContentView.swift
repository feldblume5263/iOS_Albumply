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
        ZStack {
            NavigationView {
                LibraryView(player: $player)
            }
            VStack {
                Spacer()
                MiniPlayerView(player: $player)
                    .frame(minHeight: 450, idealHeight: 600, maxHeight: 750, alignment: .bottom)
            }
            .edgesIgnoringSafeArea(.bottom)
        }
    }
}
