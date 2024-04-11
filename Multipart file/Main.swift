import UIKit
func uploadImage(paramName: String, fileName: String, image: Data, Id: Int, completion: @escaping (Error?) -> Void) {
    let urlString = "http://localhost:8080/test/test/\(Id)"
    let url = URL(string: urlString)!
    let boundary = "Boundary-\(UUID().uuidString)"
    let contentType = "multipart/form-data; boundary=\(boundary)"
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue(contentType, forHTTPHeaderField: "Content-Type")
    
    var body = Data()
    
    // Add image data
    body.append("--\(boundary)\r\n".data(using: .utf8)!)
    body.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
    body.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
    body.append(image)
    body.append("\r\n".data(using: .utf8)!)
    
    // Add end boundary
    body.append("--\(boundary)--\r\n".data(using: .utf8)!)
    
    request.httpBody = body
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        guard error == nil else {
            completion(error)
            return
        }
        
        // Check response status code if needed
        
        completion(nil)
    }
    
    task.resume()
}



func testImageUpload() {
    let paramName = "image"
    let fileName = "jpeg-optimizer_IMG_0580 2.JPG"
    let image = UIImage(named: "jpeg-optimizer_IMG_0580 2")!.jpegData(compressionQuality: 0.8)!
    let Id = 18

    
    let expectation = DispatchSemaphore(value: 0)
    
    uploadImage(paramName: paramName, fileName: fileName, image: image, Id: Id) { error in
        if let error = error {
            print("Error during image upload: \(error.localizedDescription)")
        } else {
            print("Image uploaded successfully!")
        }
        expectation.signal()
    }
    
    _ = expectation.wait(timeout: DispatchTime.now() + 10)
}
