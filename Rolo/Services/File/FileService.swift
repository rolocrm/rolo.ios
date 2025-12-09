import Foundation
import UIKit

struct FileUploadResponse: Codable {
    let key: String
    let url: String
}

class FileService {
    static let shared = FileService()
    private init() {}

    func uploadFile(token: String, image: UIImage) async throws -> FileUploadResponse {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            print("Upload file error: Failed to convert image to JPEG data")
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to convert image"])
        }

        let url = URL(string: APIConstants.Files.upload)!
        print("Upload file URL:", url)
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        print("Upload file: Image size:", imageData.count, "bytes")

        var body = Data()
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)

        request.httpBody = body

        let (data, _) = try await URLSession.shared.data(for: request)
        let response = try JSONDecoder().decode(FileUploadResponse.self, from: data)
        print("Upload file response:", response)

        return response
    }
}
