//
//  ChromeKeyEffect.swift
//  ServiceDesign
//
//  Created by Kamil on 01.12.2021.
//

import CoreImage
import UIKit

struct FilterManager {
    
    private func chromaKeyFilter(fromHue: CGFloat, toHue: CGFloat) -> CIFilter? {
        let size = 64
        var cubeRGB = [Float]()

        for z in 0 ..< size {
            let blue = CGFloat(z) / CGFloat(size-1)
            for y in 0 ..< size {
                let green = CGFloat(y) / CGFloat(size-1)
                for x in 0 ..< size {
                    let red = CGFloat(x) / CGFloat(size-1)

                    let hue = getHue(red: red, green: green, blue: blue)
                    let alpha: CGFloat = (hue >= fromHue && hue <= toHue) ? 0: 1
                    cubeRGB.append(Float(red * alpha))
                    cubeRGB.append(Float(green * alpha))
                    cubeRGB.append(Float(blue * alpha))
                    cubeRGB.append(Float(alpha))
                }
            }
        }
        
        let data = Data(buffer: UnsafeBufferPointer(start: &cubeRGB, count: cubeRGB.count))
        let colorCubeFilter = CIFilter(name: "CIColorCube", parameters: ["inputCubeDimension": size, "inputCubeData": data])
        return colorCubeFilter
    }
    
    private func getHue(red: CGFloat, green: CGFloat, blue: CGFloat) -> CGFloat {
        let color = UIColor(red: red, green: green, blue: blue, alpha: 1)
        var hue: CGFloat = 0
        color.getHue(&hue, saturation: nil, brightness: nil, alpha: nil)
        return hue
    }

    func removeGreenScreen(foregroundCIImage: CIImage) -> CIImage {
        let chromaCIFilter = chromaKeyFilter(fromHue: 0.2, toHue: 0.44)
        chromaCIFilter?.setValue(foregroundCIImage, forKey: kCIInputImageKey)
        let sourceCIImageWithoutBackground = chromaCIFilter?.outputImage
        var image = CIImage()
        if let filteredImage = sourceCIImageWithoutBackground {
            image = filteredImage
        }
        return compositeImages(foregroundCIImage: image)
    }

    private func compositeImages(foregroundCIImage: CIImage) -> CIImage {
        guard
            let backgroundUIImage =  UIImage(named: "1.jpg"),
            let backgroundCIImage = CIImage(image: backgroundUIImage)?
                //.oriented(.left)
                .transformed(by: {
                    let wantedX = foregroundCIImage.extent.size.width / backgroundUIImage.size.width
                    let wantedY = foregroundCIImage.extent.size.height / backgroundUIImage.size.height
                    return CGAffineTransform(scaleX: wantedX, y: wantedY)
                }())
        else {
            fatalError()
        }
        let compositor = CIFilter(name:"CISourceOverCompositing")
        compositor?.setValue(foregroundCIImage, forKey: kCIInputImageKey)
        compositor?.setValue(backgroundCIImage, forKey: kCIInputBackgroundImageKey)
        let compositedCIImage = compositor?.outputImage
        
        if let compositedImage = compositedCIImage {
            return compositedImage
        }
        return backgroundCIImage
    }

}


