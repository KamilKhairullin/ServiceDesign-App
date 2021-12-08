//
//  FileManager.swift
//  ServiceDesign
//
//  Created by Kamil on 01.12.2021.
//

import UIKit

class PhotoManager {
    static let shared = PhotoManager()
    
    
    private var images: [String]!
    private let imagesLimitation = 2
    
    private init() {
        self.images = [String]()
    }
    
    func addPhoto(name: String, tag: Int) {
        guard
            tag < imagesLimitation && tag >= 0
        else {
            print("Error. Tag is too big or too small.")
            return
        }
        
        if images.count < imagesLimitation {
            images.append(name)
        } else {
            images[tag] = name
        }
        
    }
    
    func getPhoto(for index: Int) -> String {
        images[index]
    }
    
    func getPhotoCount() -> Int {
        images.count
    }
    
    func getPhotoLimitation() -> Int {
        return imagesLimitation
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
}
