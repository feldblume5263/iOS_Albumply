//
//  ContentView.swift
//  Music-Player-V1
//
//  Created by Junhong Park on 2022/01/12.
//

import SwiftUI
import MediaPlayer


struct LibraryAlbumModel {
    
//    var albumID: String
//    var albumImage: UIImage
    var albumTitle: String
    var albumArtist: String
}

class LibraryAlbumsViewModel: ObservableObject {
    
    private var libraryAlbumsItemCollection: [MPMediaItemCollection]?
    @Published var libraryAlbums = [LibraryAlbumModel]()
    
//    init() {
//        refreshLibraryAlbumArray()
//    }
    
    func getLibraryAlbumByIndex(at index: Int) throws -> LibraryAlbumModel? {
        if index < 0 || index >= libraryAlbums.count {
            throw runtimeError.outOfRange
        }
        return libraryAlbums[index]
        
    }
    
    func refreshLibraryAlbums() {
        setLibraryAlbumsQuery()
        parseLibraryAlbums()
    }
    
    private func parseLibraryAlbums() {
        libraryAlbumsItemCollection?.forEach({ libraryAlbumItemCollection in
            let newAlbumTitle = libraryAlbumItemCollection.representativeItem?.albumTitle ?? undefinedString
            let newAlbumArtist = libraryAlbumItemCollection.representativeItem?.albumArtist ?? undefinedString
            let newLibraryAlbum = LibraryAlbumModel(albumTitle: newAlbumTitle, albumArtist: newAlbumArtist)
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
    
    // Test 버튼 액션
    func changeDataForTest() {
        (0 ..< getLibraryAlbumsCount()).forEach { libraryAlbumIndex in
            libraryAlbums[libraryAlbumIndex].albumArtist = "junhong"
        }
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
            Button("test button") {
                libraryAlbumsViewModel.changeDataForTest()
            }
            LazyVGrid(columns: columns, spacing: 30) {
                ForEach(0 ..< libraryAlbumsViewModel.getLibraryAlbumsCount(), id: \.self) { libraryAlbumIndex in
                    VStack {
                        Text(libraryAlbumsViewModel.libraryAlbums[libraryAlbumIndex].albumTitle)
                            .font(libraryAlbumTitleFont)
                            .foregroundColor(libraryAlbumTitleFontColor)
                        Text(libraryAlbumsViewModel.libraryAlbums[libraryAlbumIndex].albumArtist)
                            .font(libraryAlbumArtistFont)
                            .foregroundColor(libraryAlbumArtistFontColor)
                    }
                }.background(Color.green)
            }
            .navigationTitle("라이브러리")
        }.onAppear(perform: libraryAlbumsViewModel.refreshLibraryAlbums)
    }
}

