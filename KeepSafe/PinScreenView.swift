import SwiftUI

protocol PersistenceService {
    func save(data: Data, service: String, account: String) -> Bool
    func read(service: String, account: String) -> Data?
}

class MockPersistenceService: PersistenceService {
    var savedData: Data?
    var mockReadResult: Data?
    
    func save(data: Data, service: String, account: String) -> Bool {
        savedData = data
        return true
    }
    
    func read(service: String, account: String) -> Data? {
        return mockReadResult
    }
}

class KeychainPersistenceService: PersistenceService {
    func save(data: Data, service: String, account: String) -> Bool {
        let query = [
            kSecValueData: data,
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account,
        ] as CFDictionary
        
        let status = SecItemAdd(query, nil)
        
        return status == errSecSuccess
    }
    
    func read(service: String, account: String) -> Data? {
        let query = [
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecClass: kSecClassGenericPassword,
            kSecReturnData: true
        ] as CFDictionary
        
        var result: AnyObject?
        SecItemCopyMatching(query, &result)
        
        return result as? Data
    }
}

class PinViewModel: ObservableObject {
    @Published var enteredPIN: String = ""
    @Published var isPINCorrect: Bool = false
    @Published var firstRun: Bool = true
    @Published var blurRadius: CGFloat = 0
    
    var storage: PersistenceService = KeychainPersistenceService()
    
    func checkPIN() -> Bool {
        let ps = String(data: storage.read(service: "passcode", account: "user")!, encoding: .utf8) ?? ""
        if enteredPIN == ps {
            // PIN is correct
            isPINCorrect = true
            return true
        } else {
            // Incorrect PIN
            isPINCorrect = false
            firstRun = false
            resetPIN()
            return false
        }
    }
    
    func resetPIN() {
        enteredPIN = ""
    }
    
    func setPIN() {
        let st = storage.save(data: "1234".data(using: .utf8)!, service: "passcode", account: "user")
        if !st {
            print("Key Already exists or something happened")
        }
    }
}

struct PinScreenView: View {
    @EnvironmentObject private var appRootManager: AppRootManager
    @ObservedObject private var pinViewModel: PinViewModel
    @Environment(\.scenePhase) var scenePhase

    init(pinViewModel: PinViewModel) {
        self.pinViewModel = pinViewModel
    }
    
    var body: some View {
        VStack {
            Text("Enter PIN to access the app")
                .font(.headline)
                .padding()
            
            SecureField("PIN", text: $pinViewModel.enteredPIN)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .keyboardType(.numberPad)
            
            Button("Submit") {
                if pinViewModel.checkPIN() {
                    DispatchQueue.main.asyncAfter(deadline: .now()) {
                        withAnimation(.spring()) {
                            appRootManager.currentRoot = .images
                        }
                    }
                }
            }
            .padding()
            .disabled(pinViewModel.enteredPIN.isEmpty)
            
            Text("Incorrect PIN. Please try again.")
                .foregroundColor(.red)
                .padding()
                .opacity(pinViewModel.firstRun ? 0 : 1)
        }
        .onAppear {
            pinViewModel.setPIN()
            pinViewModel.resetPIN()
        }
        .blur(radius: pinViewModel.blurRadius)
        .onChange(of: scenePhase) { newPhase in
            switch newPhase {
            case .active: withAnimation { pinViewModel.blurRadius = 0 }
            case .inactive: withAnimation { pinViewModel.blurRadius = 15 }
            case .background:
                pinViewModel.blurRadius = 20
            @unknown default: print("Unknown")
            }
        }
        .onAppear {
            pinViewModel.isPINCorrect = false
        }
    }
}
