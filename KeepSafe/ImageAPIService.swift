//Created for KeepSafe in 2023
// Using Swift 5.0

import Foundation

protocol ImageAPIService {
    func fetchImages(page: Int, limit: Int) async throws -> [URL]
}

class ImageAPIServiceImpl: ImageAPIService {
    func fetchImages(page: Int, limit: Int) async throws -> [URL] {
        let url = URL(string: "https://picsum.photos/v2/list?page=\(page)&limit=\(limit)")!
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let images = try JSONDecoder().decode([ImageModel].self, from: data)
        let imageURLs = images.compactMap { URL(string: $0.downloadURL) }
        
        return imageURLs
    }
}
