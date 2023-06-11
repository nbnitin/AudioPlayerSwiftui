//
//  AudioDataModel.swift
//  AVPlayer-SwiftUI
//
//  Created by Nitin Bhatia on 02/06/23.
//  Copyright © 2023 Chris Mash. All rights reserved.
//

import Foundation

struct AudioData : Decodable  {
    let data : [AudioDataModel]?
}

struct AudioDataModel : Identifiable, Decodable {
    let id : Int?
    let audioTitle: String?
    let audioImage : String?
    let mp3URL : String?
    let duration : String?
    var isPlaying : Bool? = false
}
