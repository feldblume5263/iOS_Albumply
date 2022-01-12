//
//  ContentView.swift
//  Music-Player-V1
//
//  Created by Junhong Park on 2022/01/12.
//

import SwiftUI
import MediaPlayer

struct ContentView: View {
    
    @State var albumsCount: Int = 0
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Number of Albums")
                    .padding()
                Text("\(self.albumsCount)")
            }.navigationTitle("Library")
        }.onAppear(perform: setAlbumsCount)
    }
    
    private func setAlbumsCount() {
        if let albums = MPMediaQuery.albums().collections {
            albumsCount = albums.count
        }
    }
    
    
}


