//
//  ContentView.swift
//  Music-Player
//
//  Created by Junhong Park on 2022/01/12.
//

import SwiftUI
import MediaPlayer

struct ContentView: View {
    
    @State private var musicPlayer = MPMusicPlayerController.applicationMusicPlayer
    @State private var nowPlayingSong: MPMediaItem
    
    var body: some View {
        NavigationView {
            LibraryView()
        }
        MiniPlayerView(musicPlayer: $musicPlayer, song: $nowPlayingSong)
    }
}


struct playingDetail {
    
    
}

struct MiniPlayerView: View {
    @Binding var musicPlayer: MPMusicPlayerController
    @Binding var song: MPMediaItem
    @State var isPlaying = false
    
    var body: some View {
        HStack {
            Button {
                isPlaying.toggle()
            } label: {
                isPlaying ? Image(systemName: "play.fill") : Image(systemName: "pause.fill")
            }
            
            VStack {
                
            }
            
            
        }
        
    }
    
}
