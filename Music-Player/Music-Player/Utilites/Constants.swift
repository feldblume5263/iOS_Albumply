//
//  Constants.swift
//  Music-Player
//
//  Created by Junhong Park on 2022/01/13.
//

import SwiftUI
import MediaPlayer

// String
enum AppString {
    static let undefinedString: String = "Undefined"
}


// Font
enum AppFont {
    static let libraryAlbumTitleFont = Font.system(size: 15, weight: .semibold)
    static let libraryAlbumArtistFont = Font.system(size: 13, weight: .regular)
}


// Color

enum AppUIColor {
    static let mainUIColor = UIColor(red: 130/255, green: 200/255, blue: 227/255, alpha: 1.0)
    static let subUIColor = UIColor(red: 218/255, green: 239/255, blue: 248/255, alpha: 1.0)
}

enum AppColor {
    static let mainTextColor = Color(red: 72/255, green: 180/255, blue: 224/255)
    static let mainColor = Color(red: 130/255, green: 200/255, blue: 227/255)
    static let subColor = Color(red: 218/255, green: 239/255, blue: 248/255)
    static let libraryAlbumTitleFontColor = Color.black
    static let libraryAlbumArtistFontColor = Color.gray

}
