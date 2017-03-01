//
//  WatsonVisualRecognitionToken.swift
//  DroneCardKit
//
//  Created by Justin Weisz on 2/14/17.
//  Copyright © 2017 IBM. All rights reserved.
//

import Foundation
import Accelerate

import Freddy
import RestKit
import VisualRecognitionV3

import CardKit
import CardKitRuntime

// MARK: WatsonVisualRecognitionToken

public class WatsonVisualRecognitionToken: ExecutableTokenCard {
    private let visualRecognition: VisualRecognition
    
    init(with card: TokenCard, usingApiKey apiKey: String, version: String? = nil) {
        // latest version specified here:
        // https://www.ibm.com/watson/developercloud/visual-recognition/api/v3/#classify_an_image
        var requestedVersion = "2016-05-20"
        
        if let version = version {
            requestedVersion = version
        }
        
        self.visualRecognition = VisualRecognition(apiKey: apiKey, version: requestedVersion)
        
        super.init(with: card)
    }
    
    /// Classifies the given UIImage with Watson Visual Recognition. This method will attempt to rescale and compress
    /// the given image to fit within the 2MB upload limit.
    public func classify(image: UIImage, threshold: Double?) throws -> [DCKDetectedObject] {
        // write the UIImage to a temp file
        let cacheDir = try FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let tempFile = cacheDir.appendingPathComponent("\(UUID()).jpg")
        
        let twoMB: UInt = 2 * 1024 * 1024 - 1 // minus one byte just to make sure it fits
        if let compressedData = image.compressedJPEG(maximumSizeInBytes: twoMB) {
            try compressedData.write(to: tempFile, options: .atomic)
        }
        
        return try self.classify(imagePath: tempFile, threshold: threshold)
    }
    
    public func classify(imagePath: String, threshold: Double?) throws -> [DCKDetectedObject] {
        let url = URL(fileURLWithPath: imagePath)
        return try self.classify(imagePath: url, threshold: threshold)
    }
    
    public func classify(imagePath: URL, threshold: Double?) throws -> [DCKDetectedObject] {
        var detectedObjects: [DCKDetectedObject] = []
        
        try DispatchQueue.executeSynchronously { asyncCompletionHandler in
            self.visualRecognition.classify(imageFile: imagePath, owners: ["IBM"], classifierIDs: nil, threshold: threshold, language: "en", failure: { error in
                asyncCompletionHandler?(error)
            }, success: { (classifiedImages: ClassifiedImages) in
                
                for image in classifiedImages.images {
                    for classifier in image.classifiers {
                        for cls in classifier.classes {
                            let object = DCKDetectedObject(objectName: cls.classification, confidence: cls.score)
                            detectedObjects.append(object)
                        }
                    }
                }
                
                asyncCompletionHandler?(nil)
            })
        }
        
        return detectedObjects
    }
}

fileprivate extension UIImage {
    func compressedJPEG(maximumSizeInBytes: UInt) -> Data? {
        var quality: CGFloat = 0.9
        let minQuality: CGFloat = 0.4 // assuming anything less than this is unusable
        
        // initial compression
        guard var compressedData: Data = UIImageJPEGRepresentation(self, quality) else { return nil }
        var compressedSize = UInt(compressedData.count)
        
        while compressedSize > maximumSizeInBytes && quality > minQuality {
            quality -= 0.1
            guard let nextCompressed = UIImageJPEGRepresentation(self, quality) else { break }
            compressedData = nextCompressed
            compressedSize = UInt(compressedData.count)
        }
        
        // at this point, we may have achieved our target, but possibly not
        if compressedSize > maximumSizeInBytes {
            return nil
        }
        
        return compressedData
    }
    
    func scale(to size: CGSize) -> UIImage? {
        guard let cgImage = self.cgImage else { return nil }
        let sourceRef: CGImage = cgImage
        var format: vImage_CGImageFormat = vImage_CGImageFormat(bitsPerComponent: 8, bitsPerPixel: 32, colorSpace: nil, bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.first.rawValue), version: 0, decode: nil, renderingIntent: CGColorRenderingIntent.defaultIntent)
        var sourceBuffer: vImage_Buffer = vImage_Buffer()
        
        defer {
            sourceBuffer.data.deallocate(bytes: Int(sourceBuffer.height) * Int(sourceBuffer.height) * 4, alignedTo: 0)
        }
        
        var error = vImageBuffer_InitWithCGImage(&sourceBuffer, &format, nil, cgImage, numericCast(kvImageNoFlags))
        guard error == kvImageNoError else { return nil }
        
        //TODO: not sure we need to scale it according to the screen size as we'll be sending this to a service, we only car about filesize
        
        let scale = UIScreen.main.scale
        let destWidth = Int(size.width * scale)
        let destHeight = Int(size.height * scale)
        let bytesPerPixel = cgImage.bitsPerPixel / 8
        let destBytesPerRow = destWidth * bytesPerPixel
        let destData = UnsafeMutablePointer<UInt8>.allocate(capacity: destHeight * destBytesPerRow)
        
        defer {
            destData.deallocate(capacity: destHeight * destBytesPerRow)
        }
        
        var destBuffer = vImage_Buffer(data: destData, height: vImagePixelCount(destHeight), width: vImagePixelCount(destWidth), rowBytes: destBytesPerRow)
        
        // now we scale it
        error = vImageScale_ARGB8888(&sourceBuffer, &destBuffer, nil, numericCast(kvImageHighQualityResampling))
        guard error == kvImageNoError else { return nil }
        
        // and create it
        let destCGImage = vImageCreateCGImageFromBuffer(&destBuffer, &format, nil, nil, numericCast(kvImageNoFlags), &error)
        guard error == kvImageNoError else { return nil }
        
        return destCGImage.flatMap {
            UIImage(cgImage: $0.takeRetainedValue(), scale: 0.0, orientation: self.imageOrientation)
        }
    }
    
    var fileSize: Int {
        guard let cgImage = self.cgImage else { return 0 }
        let byteSize: Int = cgImage.height * cgImage.bytesPerRow
        return byteSize
    }
}
