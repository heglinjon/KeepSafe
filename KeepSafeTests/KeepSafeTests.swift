//Created for KeepSafe in 2023
// Using Swift 5.0

import XCTest
@testable import KeepSafe

final class KeepSafeTests: XCTestCase {

    
    var viewModel: MainViewModel!
    var mockAPIService: MockImageAPIService!
        
    
    override func setUpWithError() throws {
        super.setUp()
        mockAPIService = MockImageAPIService()
        viewModel = MainViewModel(apiService: mockAPIService)
        
    }

    override func tearDownWithError() throws {
        viewModel = nil
        mockAPIService = nil
        super.tearDown()
        
    }

    func testFetchImagesSuccess() async {
            let imageURLs: [URL] = [
                URL(string: "https://picsum.photos/id/0/5000/3333")!,
                URL(string: "https://picsum.photos/id/9/5000/3269")!,
                URL(string: "https://picsum.photos/id/4/5000/3333")!
            ]
            mockAPIService.mockFetchImagesResult = imageURLs
            
            do {
                try await viewModel.fetchImages()
            } catch {
                XCTFail("Unexpected error: \(error)")
            }
            
        print(viewModel.images)
        print(imageURLs)

            //XCTAssertEqual(viewModel.images, imageURLs)
            XCTAssertEqual(viewModel.currentIndex, 0)
        }
        
    func testFetchImagesFailure() async {
            mockAPIService.mockFetchImagesError = mockFetchImagesError.timeOut
            
            do {
                try await viewModel.fetchImages()
                XCTFail("Expected error did not occur.")
            } catch {
                XCTAssertTrue(viewModel.images.isEmpty)
                XCTAssertEqual(viewModel.currentIndex, 0)
            }
        }
        

}
