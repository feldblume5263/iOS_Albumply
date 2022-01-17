//
//  AuthViewModel.swift
//  Music-Player
//
//  Created by Junhong Park on 2022/01/17.
//

import SwiftUI
import MediaPlayer

class AuthViewModel: ObservableObject {
    @Published var authStatus: Bool = true
    
    init() {
        getAuthrization()
    }
    
    func getAuthrization()  {
        DispatchQueue.main.async {
            let status = MPMediaLibrary.authorizationStatus()
            if(status == MPMediaLibraryAuthorizationStatus.authorized){
                self.authStatus = true
            }else{
                MPMediaLibrary.requestAuthorization() { status in
                    DispatchQueue.main.async {
                        if status == .authorized {
                            self.authStatus = true
                        }else{
                            self.authStatus = false
                        }
                    }
                }
            }
        }
    }
}
