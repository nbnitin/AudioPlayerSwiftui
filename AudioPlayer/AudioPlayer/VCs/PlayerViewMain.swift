//
//  PlayerView.swift
//  AudioPlayer
//
//  Created by Nitin Bhatia on 02/06/23.
//

import SwiftUI

struct PlayerViewMain: View {
    @State var currentValue : CGFloat = 3.0
    var body: some View {
        ZStack {
            
            Image("audioImage")
            VStack {
                Spacer()
                Slider(value: $currentValue)
            }
                
            HStack {
                Button(action: {
                    
                }) {
                    Image(systemName: "backward")
                    
                }
                .foregroundColor(.white)
                
                Button(action: {
                    
//                    if $isPlaying.wrappedValue {
//                        playerManager.player.pause()
//                        isPlaying = false
//                    } else {
//                        playerManager.player.play()
//                        isPlaying = true
//                    }
                }) {
                    //Image(systemName: $isPlaying.wrappedValue ? "pause" :  "play")
                    Image(systemName: "play")
                }
                .foregroundColor(.white)
                .frame(width: 32)
                
                Button(action: {
                    
                }) {
                    Image(systemName: "forward")
                    
                }
                .foregroundColor(.white)
            }
            
            .padding(10)
            
            }
           
        }
    }

struct PlayerView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerViewMain()
    }
}
