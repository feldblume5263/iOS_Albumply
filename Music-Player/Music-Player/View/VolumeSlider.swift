//
//  VolumeSlider.swift
//  Music-Player
//
//  Created by Junhong Park on 2022/01/18.
//

import SwiftUI
import MediaPlayer

struct VolumeSlider: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        
        let view = MPVolumeView(frame: .zero)
        let subViews = view.subviews
        for current in subViews {
            if current.isKind(of: UISlider.self) {
                let tempSlider = current as! UISlider
                tempSlider.minimumTrackTintColor = AppUIColor.mainUIColor
                tempSlider.maximumTrackTintColor = AppUIColor.subUIColor
                return current
            }
        }
        return view
    }
    
    func updateUIView(_ view: UIView, context: Context) {
        
    }
}
