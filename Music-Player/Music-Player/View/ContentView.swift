//
//  ContentView.swift
//  Music-Player
//
//  Created by Junhong Park on 2022/01/12.
//

import SwiftUI
import MediaPlayer

struct PlayingSong {
    var title: String
    var artist: String
    var artWorkImage: UIImage
}

struct ContentView: View {
    
    @State private var musicPlayer = MPMusicPlayerController.applicationMusicPlayer
    @State private var playingSong = PlayingSong(title: "", artist: "", artWorkImage: UIImage())
    
    var body: some View {
        NavigationView {
            LibraryView(playingSong: $playingSong)
        }
        MiniPlayerView(musicPlayer: $musicPlayer, playingSong: $playingSong)
    }
}


struct MiniPlayerViewModel {
    
    
}

struct MiniPlayerView: View {
    @Binding var musicPlayer: MPMusicPlayerController
    @Binding var playingSong: PlayingSong
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
                Text(playingSong.title)
                Text(playingSong.artist)
            }
            Spacer()
            let songArtWork = playingSong.artWorkImage
            Image(uiImage: songArtWork)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: 10, maxHeight: 10)
                .background(Color.gray)
        }
        .frame(height: 50)
        .padding()
    }
    
}
