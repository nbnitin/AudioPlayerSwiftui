//
//  NetworkManager.swift
//  AVPlayer-SwiftUI
//
//  Created by Nitin Bhatia on 02/06/23.
//  Copyright © 2023 Chris Mash. All rights reserved.
//

import Foundation


class NetworkManager {
    
    func getData(completion: @escaping(AudioData?)->Void)  {
        
        if let path = Bundle.main.url(forResource: "AudioData", withExtension: ".json") {
            if let jsonData = try? Data(contentsOf: path) {
                if let audioData = try? JSONDecoder().decode(AudioData.self, from: jsonData) {
                    completion(audioData)
                }
             }
        }
        
      
        
        
    }
}
