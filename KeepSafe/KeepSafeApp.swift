//Created for KeepSafe in 2023
// Using Swift 5.0

import SwiftUI

final class AppRootManager: ObservableObject {
    
    @Published var currentRoot: AppRoots = .home
    
    enum AppRoots {
        case home
        case images
    }
}

@main
struct KeepSafeApp: App {

    @StateObject private var appRootManager = AppRootManager()
    let apiService: ImageAPIService = ImageAPIServiceImpl()
    let PinService = PinViewModel()
    
    
    var body: some Scene {
        WindowGroup {
            Group {
                switch appRootManager.currentRoot {
                case .home:
                    PinScreenView(pinViewModel: PinService)
                    
                    
                case .images:
                    ContentView(viewModel: MainViewModel(apiService: apiService))
                }
            }
            .environmentObject(appRootManager)
        }
    }
}
