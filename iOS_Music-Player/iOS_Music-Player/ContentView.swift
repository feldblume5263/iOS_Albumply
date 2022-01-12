//
//  ContentView.swift
//  iOS_Music-Player
//
//  Created by Junhong Park on 2022/01/12.
//

import Foundation
import SwiftUI
import Combine


struct MyScoreView: View {
    @Binding var score: Int
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    var body: some View {
        VStack {
            Text("\(self.score)")
            Button("클릭시 score 증가") {
                self.score += 1
            }
            .padding()
            .background(colorScheme == .dark ? Color.orange : Color.green)
            .foregroundColor(colorScheme == .dark ? Color.black : Color.pink)
        }
        .padding()
        .background(Color.yellow)
    }
}

class UserSetting: ObservableObject {
    @Published var score: Int = 0
}


struct ContentView: View {
    @ObservedObject var userSetting = UserSetting()

    var body: some View {

        VStack {
            Text("\(userSetting.score)")
                .font(.largeTitle)

            Button("클릭시 스코어 증가") {
                self.userSetting.score += 1
            }
            
            Divider()
                .padding()
            
            MyScoreView(score: self.$userSetting.score)
        }
    }
}

//struct Episode {
//    let song: String
//    let singer: String
//    let track: String
//}
//
//struct ContentView: View {
//
//    let episode = Episode(song: "Dynamite", singer: "BTS", track: "DayTime Version")
//    @State private var isPlaying = false
//
//    var body: some View {
//
//        VStack {
//            Text(self.episode.song)
//                .font(.title)
//                .foregroundColor(self.isPlaying ? .blue : .black)
//
//            Text(self.episode.track)
//                .font(.footnote)
//                .foregroundColor(.secondary)
//
//            Text(self.episode.singer)
//                .foregroundColor(.secondary)
//
//            PlayButton(isPlaying: $isPlaying)
//        }
//    }
//}
//
//
//struct PlayButton: View {
//
//    @Binding var isPlaying: Bool
//
//    init(isPlaying: Binding<Bool> = .constant(true)) {
//        self._isPlaying = isPlaying
//    }
//
//    var body: some View {
//        Button(action: {
//            self.isPlaying.toggle()
//        }) {
//            Image(systemName: "play.fill")
//                .font(.system(size: 30))
//                .foregroundColor(self.isPlaying ? .blue : .black)
//        }.padding(15)
//    }
//}
//





//struct ContentView: View {
//    @State var name: String = ""
//
//    var body: some View {
//        VStack {
//            Text("Your name is \(name)")
//                .padding()
//            TextField("이름", text: $name)
//                .multilineTextAlignment(.center)
//                .padding(12)
//
//            Button(action: printName) {
//                Text("Show name Value")
//            }
//        }
//    }
//
//    private func printName() {
//        print(self.name)
//    }
//}


//
//class User: ObservableObject {
//    @Published var firstName = ""
//    @Published var lastName = ""
//}
//
//
//struct ContentView: View {
//
//    @ObservedObject var user = User()
////    @State private var user = User()
//
//    var body: some View {
//
//        VStack {
//            Text("Your name is \(user.firstName)\(user.lastName).")
//                .font(.title)
//                .fontWeight(.bold)
//                .padding(30)
//
//            List {
//                Section {
//                    TextField("Last name",text: $user.lastName)
//                    TextField("First name", text: $user.firstName)
//                } header: {
//                    Text("Enter your Name")
//                }
//
//            }
//        }
//    }
//}
//
//



////Models
//struct Person {
//    var name: String
////    var age: Int
//    var birthday: Date
//}
//
//
//class personViewModel: ObservableObject {
//
//    @Published var person = Person(name: "undefined", birthday: Date())
//
//    var name: String {
//        person.name
//    }
//
//    var age: String {
//        return "28"
//    }
//
//    func changeName(_ name: String) {
//        person.name = name
//    }
//}
//
//class MyTimer: ObservableObject {
//    @Published var value: Int = 0
//
//    init() {
//
//        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
//            self.value += 1
//        }
//    }
//}
//
////Views
//struct ContentView: View {
//
//    @StateObject var viewModel = personViewModel()
//    @ObservedObject var timer = MyTimer()
//
//    var body: some View {
//
//        VStack {
//            Text(viewModel.name)
//                .padding()
//                .padding()
//            Text(viewModel.age)
//            Button("Change Name") {
//                viewModel.changeName("Junhong")
//            }
//            Text("\(self.timer.value)")
//                .font(.largeTitle)
//
//
//        }
//    }
//}





//struct ContentView: View {
//
//    @State private var isEnabled: Bool = false
//
//    var body: some View {
//        VStack(alignment: .center, spacing: 60) {
//            Toggle(isOn: $isEnabled) {
//                Text(isEnabled ? "Enable" : "Disbable")
//            }
//            Button {
//                isEnabled.toggle()
//            }
//        label: {
//            Text(isEnabled ? "Disable" : "Enable")
//        }
//        }
//    }
//}
//
//class Episode {
//    @State private var status: Bool
//    @State private var statusString: String
//
//    init() {
//        self.status = false
//        self.statusString = "Pause"
//    }
//}
//
//
//struct PlayButton: View {
//    @Binding var isPlaying: Bool
//
//    var episode: Episode
//
//    var body: some View {
//        Button(action: {
//            self.isPlaying.toggle()
//        }) {
//            Image(systemName: isPlaying ? "pause.circle" : "play.circle")
//        }
//    }
//}
//
//
//
//struct PlayerView: View {
//    var episode: Episode
//
//    @State private var isPlaying: Bool = false
//    @Binding var status: Bool
//
//    var body: some View {
//        VStack {
//            PlayButton(isPlaying: $isPlaying, episode: episode)
//        }
//    }
//}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
