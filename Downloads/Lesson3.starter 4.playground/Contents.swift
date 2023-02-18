import UIKit


class Image: Persistance, Compression {
    required convenience init?(named name: String, data: Data, compressionQuality: Double) {
        guard let image = UIImage.init(data: data) else { return nil }
        guard let jpegData = image.jpegData(compressionQuality: CGFloat(compressionQuality)) else { return nil }
        self.init(name: name, data: jpegData)
    }
    
    func save(to url: URL) throws {
        try self.imageData.write(to: url)
    }
    
    required convenience init(name: String, contentsOf url: URL) throws {
        let data = try Data(contentsOf: url)
        self.init(name: name, data: data)
    }
    
    fileprivate var imageName: String
    fileprivate var imageData: Data

    var name: String {
        return imageName
    }

    init(name: String, data: Data) {
        imageName = name
        imageData = data
    }
    var base64Encoded: String {
        return imageData.base64EncodedString()
    }
}

// Test
var image = Image(name: "Pic", data: Data(repeating: 0, count: 100))
print(image.base64Encoded)

do {
    // persist image
    let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false)
    let imageURL = documentDirectory.appendingPathComponent("MyImage")
    try image.save(to: imageURL)
    print("Image saved successfully to path \(imageURL)")

    // load image from persistence
    let storedImage = try Image.init(name: "MyRestoredImage", contentsOf: imageURL)
    print("Image loaded successfully from path \(imageURL)")
} catch {
    print(error)
}

protocol Persistance {
    func save(to url: URL) throws
    init(name: String, contentsOf url: URL) throws
}

protocol Compression {
    init?(named name: String, data: Data, compressionQuality: Double)
}
