//Created for KeepSafe in 2023
// Using Swift 5.0

import XCTest
@testable import KeepSafe


final class PINViewModelTest: XCTestCase {

    
    var viewModel: PinViewModel!

    override func setUpWithError() throws {
        super.setUp()
        viewModel = PinViewModel()
        
    }

    override func tearDownWithError() throws {
        viewModel = nil
        super.tearDown()
    }

    func testCheckPINCorrect() {
         let mockStorage = MockPersistenceService()
         mockStorage.mockReadResult = "1234".data(using: .utf8)
         viewModel.storage = mockStorage
         viewModel.enteredPIN = "1234"
         
         let result = viewModel.checkPIN()
         
         XCTAssertTrue(result)
         XCTAssertTrue(viewModel.isPINCorrect)
     }
     
     func testCheckPINIncorrect() {
         let mockStorage = MockPersistenceService()
         mockStorage.mockReadResult = "1234".data(using: .utf8)
         viewModel.storage = mockStorage
         viewModel.enteredPIN = "0000"
         
         let result = viewModel.checkPIN()
         
         XCTAssertFalse(result)
         XCTAssertFalse(viewModel.isPINCorrect)
         XCTAssertFalse(viewModel.firstRun)
         XCTAssertTrue(viewModel.enteredPIN.isEmpty)
     }
     
     func testResetPIN() {
         viewModel.enteredPIN = "1234"
         viewModel.resetPIN()
         
         XCTAssertTrue(viewModel.enteredPIN.isEmpty)
     }
     
     func testSetPIN() {
         let mockStorage = MockPersistenceService()
         viewModel.storage = mockStorage
         viewModel.setPIN()
         
         XCTAssertEqual(mockStorage.savedData, "1234".data(using: .utf8))
     }

}
