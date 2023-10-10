import SwiftUI

protocol PersistenceService {
    func save(data: Data, service: String, account: String) -> Bool
    func read(service: String, account: String) -> Data?
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

struct PinScreenView: View {
    @EnvironmentObject private var appRootManager: AppRootManager
    
    @State private var enteredPIN: String = ""
    @State private var isPINCorrect: Bool = false
    let apiService: ImageAPIService = ImageAPIServiceImpl()
    @State private var firstRun: Bool = true
    @Environment(\.scenePhase) var scenePhase
    @State var blurRadius: CGFloat = 0
    
    let storage: PersistenceService = KeychainPersistenceService()
    
    var body: some View {
        VStack {
            Text("Enter PIN to access the app")
                .font(.headline)
                .padding()
            
            SecureField("PIN", text: $enteredPIN)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .keyboardType(.numberPad)
            
            Button("Submit") {
                if checkPIN() {
                    DispatchQueue.main.asyncAfter(deadline: .now()) {
                        withAnimation(.spring()) {
                            appRootManager.currentRoot = .images
                        }
                    }
                }
            }
            .padding()
            .disabled(enteredPIN.isEmpty)
            
            Text("Incorrect PIN. Please try again.")
                .foregroundColor(.red)
                .padding()
                .opacity(firstRun ? 0 : 1)
            
        }
        .onAppear {
            setPIN()
            resetPIN()
        }
        .blur(radius: blurRadius)
        .onChange(of: scenePhase) { newPhase in
            switch newPhase {
            case .active: withAnimation { blurRadius = 0 }
            case .inactive: withAnimation { blurRadius = 15 }
            case .background:
                blurRadius = 20
            @unknown default: print("Unknown")
            }
        }
        .onAppear {
            isPINCorrect = false
        }
    }
    
    private func checkPIN() -> Bool {
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
    
    private func resetPIN() {
        enteredPIN = ""
    }
    
    private func setPIN() {
        
        let st = storage.save(data: "1234".data(using: .utf8)!, service: "passcode", account: "user")
        if !st {
            print("Key lready exists or smth happened")
        }
    }
}
