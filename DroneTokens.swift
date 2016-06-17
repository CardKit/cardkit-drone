import Foundation

import CardLib

public protocol MovementToken : Token {

    func goTo(coord : InputCoordinate2D)
    
    func hover()
    
}

public class DummyMovementToken : MovementToken {
    
    public static let defaultInstance = DummyMovementToken()
    
    public let id = "dummyMovement"
    
    private init() {
    }
    
    public func goTo(coord: InputCoordinate2D) {
        print("move to \(coord)")
    }
    
    public func hover() {
    }
    
}

public protocol CameraToken : Token {
    
    func takePicture()
    
    func startRecordVideo()
    
    func stopRecordVideo()
    
}

public class DummyCameraToken : CameraToken {
    
    public static let defaultInstance = DummyCameraToken()
    
    public let id = "dummyCamera"
    
    private init() {
    }
    
    public func takePicture() {
    }
    
    public func startRecordVideo() {
    }
    
    public func stopRecordVideo() {
    }
}