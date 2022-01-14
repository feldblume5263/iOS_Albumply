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
    @State private var songQueue: [MPMediaItem]? = []
    
    var body: some View {
        NavigationView {
            LibraryView(songQueue: $songQueue)
        }
        MiniPlayerView(musicPlayer: $musicPlayer, songQueue: $songQueue)
    }
}


struct MiniPlayerViewModel {
    
    
}

struct MiniPlayerView: View {
    
    @Binding var musicPlayer: MPMusicPlayerController
    @Binding var songQueue: [MPMediaItem]?
    @State var isPlaying = false
    
    
    var body: some View {
        HStack {
            Button {
                isPlaying.toggle()
            } label: {
                isPlaying ? Image(systemName: "play.fill") : Image(systemName: "pause.fill")
            }
            Spacer()
            VStack {
                Text("")
                Text("")
            }
            Spacer()
            Image(uiImage: UIImage())
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: 10, maxHeight: 10)
                .background(Color.gray)
        }
        .frame(height: 50)
        .padding()
    }
    
}
