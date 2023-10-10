//Created for KeepSafe in 2023
// Using Swift 5.0

import Foundation

class MainViewModel: ObservableObject {
    @Published var images: [URL] = []
    private var currentPage = 1
    private let limit = 10
    private let apiService: ImageAPIService
    @Published var currentIndex = 0
    
    init(apiService: ImageAPIService) {
        self.apiService = apiService
        Task {
            do {
                try await fetchImages()
            } catch {
                print("Error fetching images: \(error)")
            }
        }
    }
    
     func fetchImages() async throws {
        let imageURLs = try await apiService.fetchImages(page: currentPage, limit: limit)
        
        DispatchQueue.main.async {
            self.images.append(contentsOf: imageURLs)
            self.currentPage += 1
        }
    }
    
    func loadMoreImagesIfNeeded(currentItemIndex: Int) {
        if currentItemIndex == images.count - 1 {
            Task {
                do {
                    try await fetchImages()
                } catch {
                    print("Error fetching images: \(error)")
                }
            }
        }
    }
    
    func swipeLeft() {
        if currentIndex < images.count - 1 {
            currentIndex += 1
        }
    }
    
    func swipeRight() {
        if currentIndex > 0 {
            currentIndex -= 1
        }
    }
}
