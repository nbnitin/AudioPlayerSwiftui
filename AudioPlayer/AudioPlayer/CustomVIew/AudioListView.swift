//
//  AudioListView.swift
//  AudioPlayer
//
//  Created by Nitin Bhatia on 23/05/23.
//

import SwiftUI

struct AudioListView: View {
    //properties
    @State var name: String
    @Binding var selectedId : Int
    let data : AudioDataModel
    //body
    var body: some View {
        HStack {
            Label(name, image: "")
                .labelStyle(.titleOnly)
            Spacer()
            
            Image(systemName: selectedId == data.id ? "stop" : "play")
        }
        
        .listRowBackground(Color.white)
    }
       
}

struct AudioListView_Previews: PreviewProvider {
    static var previews: some View {
        @State var item : Int = 0
        AudioListView(name: "Hello", selectedId: $item, data: AudioDataModel(id: 0, audioTitle: "", audioImage: "", mp3URL: "", duration: ""))
    }
}
