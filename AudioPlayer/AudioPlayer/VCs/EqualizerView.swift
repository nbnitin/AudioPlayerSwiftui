//
//  EqualizerView.swift
//  AudioPlayer
//
//  Created by Nitin Bhatia on 23/05/23.
//

import SwiftUI

struct EqualizerView: View {
    @State private var bass = 50.0
    @State private var middle = 50.0
    @State private var treble = 50.0
    var body: some View {
        VStack {
            Label("Equalizer", image: "")
                .labelStyle(.titleOnly)
                .fontWeight(.heavy)
                .font(.system(size: 40))
            HStack {
                VStack {
                    HStack {
                        Label("Bass", image: "")
                            .labelStyle(.titleOnly)
                            .frame(width: 60)
                        Slider(
                            value: $bass,
                            in: 0...100,
                            onEditingChanged: { editing in
                                //isEditing = editing
                            }
                        )
                        .padding(.trailing)
                    }
                    HStack {
                        Label("Middle", image: "")
                            .labelStyle(.titleOnly)
                            .frame(width: 62)
                        Slider(
                            value: $middle,
                            in: 0...100,
                            onEditingChanged: { editing in
                                //isEditing = editing
                            }
                        )
                        .padding(.trailing)
                    }
                    HStack {
                        Label("Treble", image: "")
                            .labelStyle(.titleOnly)
                            .frame(width: 60)
                        Slider(
                            value: $treble,
                            in: 0...100,
                            onEditingChanged: { editing in
                                //isEditing = editing
                            }
                        )
                        .padding(.trailing)
                    }
                }
            }
        }
    }
}

struct EqualizerView_Previews: PreviewProvider {
    static var previews: some View {
        EqualizerView()
    }
}
