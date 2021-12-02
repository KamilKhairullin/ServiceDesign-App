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
    
    private init() {
        self.images = [String]()
    }
    
    func addPhoto(name: String) {
        images.append(name)
        print("\(name) added.")
    }
    
    func getPhoto(for index: Int) -> String {
        images[index]
    }
    
    func getPhotoCount() -> Int {
        images.count
    }
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
}
