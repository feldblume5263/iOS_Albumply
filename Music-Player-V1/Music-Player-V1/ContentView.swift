//
//  ContentView.swift
//  Music-Player-V1
//
//  Created by Junhong Park on 2022/01/12.
//

import SwiftUI
import MediaPlayer


struct LibraryAlbum {
    
//    var albumID: String
//    var albumImage: UIImage
    var albumTitle: String
}

class LibraryAlbumsViewModel: ObservableObject {
    
    private var libraryAlbumsItemCollection: [MPMediaItemCollection]?
    @Published var libraryAlbums = [LibraryAlbum]()
    
    init() {
        setLibraryAlbumsQuery()
        makeLibraryAlbumsArray()
    }
    
    private func makeLibraryAlbumsArray() {
        libraryAlbumsItemCollection?.forEach({ libraryAlbumItemCollection in
            let newAlbumTitle = libraryAlbumItemCollection.representativeItem?.albumTitle
            let newLibraryAlbum = LibraryAlbum(albumTitle: newAlbumTitle ?? "Undefined")
            libraryAlbums.append(newLibraryAlbum)
        })
    }
    
    private func setLibraryAlbumsQuery() {
        if let libraryAlbums = MPMediaQuery.albums().collections {
            self.libraryAlbumsItemCollection = libraryAlbums
        } else {
            self.libraryAlbumsItemCollection = nil
        }
    }
    // 라이브러리 앨범 개수 반환
    func getLibraryAlbumsCount() -> Int {
        return libraryAlbums.count
    }
}


struct ContentView: View {
    
    var body: some View {
        NavigationView {
            LibraryAlbumsView()
                .padding(EdgeInsets(top: 50, leading: 0, bottom: 0, trailing: 0))
        }
    }
}


struct LibraryAlbumsView: View {
    
    @ObservedObject var libraryAlbumsViewModel = LibraryAlbumsViewModel()
    
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 30) {
                ForEach(0 ..< libraryAlbumsViewModel.libraryAlbums.count, id: \.self) { libraryAlbumIndex in
                    VStack {
                        Text(libraryAlbumsViewModel.libraryAlbums[libraryAlbumIndex].albumTitle)
                    }
                }.background(Color.green)
            }
            .navigationTitle("라이브러리")
        }
    }
}

