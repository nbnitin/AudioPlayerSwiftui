//
//  ContentView.swift
//  AudioPlayer
//
//  Created by Nitin Bhatia on 22/05/23.
//

import SwiftUI
import AVKit
import Combine

struct AVPlayerControllerRepresented : UIViewControllerRepresentable {
    var player : AVPlayer
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        controller.player = player
        controller.showsPlaybackControls = false
        return controller
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        
    }
    
}

class PlayerManager : ObservableObject {
    var player : AVPlayer = AVPlayer()
    @Published private var playing = false
   // @Published var currentTimeInSeconds : Float64 = 0
    let publisher = PassthroughSubject<Float64, Never>()
    //let timeObserver: Any
    
    func playItem(url: String) {
        let playerItem = AVPlayerItem(url: URL(string: url)!)
        
        player = AVPlayer(playerItem: playerItem)
        
        play()
    }
    
    func play() {
        player.play()
        playing = true
        
        setObserver()
    }
    
    func setObserver() {
        player.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: 1), queue: DispatchQueue.main, using: { (time) in
            
            let currentTime = CMTimeGetSeconds(self.player.currentTime())
                
            let currentTimeInSeconds = currentTime
            self.publisher.send(currentTimeInSeconds)


           })
    }
    
    func playPause() {
        if playing {
            player.pause()
        } else {
            player.play()
        }
        playing.toggle()
    }
    
    func seekTo(_ time: Double) {
        //player.
    }
    
}

struct ContentView: View {
    // MARK: - PROPERTIES
    @State private var showingSheet = false
    @State private var isPlaying = false
    @State private var showControl = true
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @StateObject var playerManager = PlayerManager()
    @State private var currentValue: Double = 0
    @State private var currentDisplayValue : String = "00:00"
    @State private var totalDuration = TimeInterval()
    @State private var audioDataList : [AudioDataModel]?
    @State private var audioImage : String?
    @State private var selectedAudioId: Int = -1
    
    func cmTimeToSeconds(_ time: CMTime) -> TimeInterval? {
        let seconds = CMTimeGetSeconds(time)
        if seconds.isNaN {
            return nil
        }
        return TimeInterval(seconds)
    }

    
    // MARK: - BODY
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0) {
            ZStack {
                AVPlayerControllerRepresented(player: playerManager.player)
//                               .onAppear {
//                                   //playerManager.play()
//                                  // isPlaying = true
//
//
//                                   }
//
//
//
//
//
//
//                               }
                               .onReceive(playerManager.publisher, perform: {value in
                                   
                                   currentDisplayValue = (NSString(format: "%02d:%02d", Int(value) / 60, Int(value) % 60) as String)//"\(secs/60):\(secs%60)"
                                               //}
                                   currentValue = value
                               })
                               .frame(height: 50)
               
                // MARK: - Image
                if let audioImage {
                    AsyncImage(url: URL(string: audioImage), scale: 1) { image in
                                image
                            .resizable()
                           
                            } placeholder: {
                                Color.gray
                            }
                            .frame(height: 300)
                } else {
                    Image("audioImage")
                    
                        .resizable()
                    //.aspectRatio(contentMode: .fit)
                        .frame(height: 300)
                }
                
                    // MARK: - Audio controls
                    if $showControl.wrappedValue {
                        HStack(alignment: .top, spacing: 50.0) {
                            Button(action: {
                                
                            }) {
                                Image(systemName: "backward")
                                
                            }
                            .foregroundColor(.white)
                            
                            Button(action: {
                                
                                if $isPlaying.wrappedValue {
                                    playerManager.player.pause()
                                    isPlaying = false
                                } else {
                                    playerManager.play()
                                    isPlaying = true
                                }
                            }) {
                                Image(systemName: $isPlaying.wrappedValue ? "pause" :  "play")
                            }
                            .foregroundColor(.white)
                            .frame(width: 32)
                            
                            Button(action: {
                                
                            }) {
                                Image(systemName: "forward")
                                
                            }
                            .foregroundColor(.white)
                        }
                        
                      //  .padding(10)
                       
                    }
                        
                    
                VStack(alignment: .leading,spacing: 5) {
                    
                    Spacer()
                    if $showControl.wrappedValue {
                        Text("\($currentDisplayValue.wrappedValue)")
                            .multilineTextAlignment(.leading)
                            .foregroundColor(.white)
                            .padding(.horizontal, 5)
                            
                    }
                    
                    if $showControl.wrappedValue {
                        Slider(value: $currentValue, in: 0...totalDuration, onEditingChanged: sliderEditingChanged)
                            .padding(.horizontal, 5)                //.padding(.bottom, 10)
                    } else {
                        
                        ProgressView(value: currentValue / 100, total: totalDuration / 100)
                        //dividing value by 100 beucase progress view takes value from 0 to 1 where 1 = 100%, if value is 50% and it should be provided in 0.5.
                    }
                    
                }
                .frame(width: UIScreen.main.bounds.width)
            }
            .frame(height: 200)
            
           
            
            .onAppear() {
                self.startTimer()
            }
            
            .onTapGesture {
                withAnimation(.easeInOut(duration: 0.10)) {
                    showControl = true
                }
                startTimer()
            }
            
            .onReceive(timer) { input in
                withAnimation(.easeInOut(duration: 0.10)) {
                    showControl = false
                }
                
                stopTimer()
            }
            .edgesIgnoringSafeArea(.top)
           
          
                //: ZStack
            
            // MARK: - preset and equalizer control section
            ZStack {
                // MARK: - preset and equalizer control section ends
                List(audioDataList ?? []) {item in
                    AudioListView(name: item.audioTitle ?? "", selectedId: $selectedAudioId, data: item)
                        
                    //.listRowSeparator(.visible, edges: .bottom)
                        .alignmentGuide(
                            .listRowSeparatorTrailing
                        ) { dimensions in
                            dimensions[.trailing]
                        }
                    
                        .padding(10)
                        .onTapGesture {
                            let index = audioDataList?.firstIndex(where: {$0.id == item.id})
                            selectedAudioId = item.id ?? -1
                            debugPrint(item.id)
                            playerManager.playItem(url: item.mp3URL!)
                            audioImage = item.audioImage
                            audioDataList?[index ?? 0].isPlaying = true
                            Task {
                                if let x = try await  playerManager.player.currentItem?.asset.load(.duration) {
                                    totalDuration = cmTimeToSeconds(x)!
                                    isPlaying = true
                                }
                            }
                            
                        }
                }
                
                .listStyle(.inset)
                .padding(.top,55)
               
                VStack(spacing: 0) {
                    ZStack {
                        Rectangle()
                            .background(.white)
                            .shadow(color: .gray,radius: 5, x: 0, y: 5)
                            .foregroundColor(.white)
                            .frame(height: 50)
                            .alignmentGuide(
                                .top
                            ) { dimensions in
                                dimensions[.top]
                            }
                        
                        
                        HStack {
                            Label("Preset:", image: "")
                                .labelStyle(.titleOnly)
                                .padding(.leading,10)
                            Label("Classic", image: "")
                                .labelStyle(.titleOnly)
                                .font(.subheadline)
                                .frame(height: 60)
                            Spacer()
                            Button("Equ", action: {
                                showingSheet.toggle()
                            })
                            .frame(height: 50)
                            .padding(.trailing, 10)
                            
                        }
                    }
                    Spacer()
                }
                
            }
            
        }
        .padding(.top,-9)
       
        //: VStack
        .sheet(isPresented: $showingSheet) {
                    EqualizerView()
                .presentationDetents([.medium, .large])
                
        }
        
        .onAppear(perform: {
            loadAudioData()
        })
    }
        
    
    private func sliderEditingChanged(editingStarted: Bool) {
        if editingStarted {
            // Tell the PlayerTimeObserver to stop publishing updates while the user is interacting
            // with the slider (otherwise it would keep jumping from where they've moved it to, back
            // to where the player is currently at)
            playerManager.player.pause()
        }
        else {
            // Editing finished, start the seek
            //state = .buffering
            let targetTime = CMTime(seconds: currentValue,
                                    preferredTimescale: 600)
            playerManager.player.seek(to: targetTime) { _ in
                // Now the (async) seek is completed, resume normal operation
                playerManager.player.play()
                //self.state = .playing
            }
        }
    }
    
    func loadAudioData() {
        NetworkManager().getData(completion: {data in
            self.audioDataList = data?.data
        })
    }
    
    func startTimer() {
        timer = Timer.publish(every: 20, on: .main, in: .common).autoconnect()
        }
    
    func stopTimer() {
        self.timer.upstream.connect().cancel()
    }
    
}

// MARK: - PREVIEW
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
