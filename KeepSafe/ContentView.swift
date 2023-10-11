//Created for KeepSafe in 2023
// Using Swift 5.0

import SwiftUI
import Kingfisher

struct ContentView: View {
    @ObservedObject var viewModel: MainViewModel
    @EnvironmentObject private var appRootManager: AppRootManager
    @Environment(\.scenePhase) var scenePhase
    @State var blurRadius : CGFloat = 0

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 150),spacing: 10)], spacing: 16) {
                    Section(header: Text("Images").font(.title)) {
                        ForEach(viewModel.images, id: \.self) { imageURL in
                            NavigationLink(destination: FullScreenView(viewModel: viewModel, imageURL: imageURL)) {
                                KFImage(imageURL)
                                    .placeholder{
                                        ProgressView()
                                            .progressViewStyle(CircularProgressViewStyle(tint: Color("ColorAccent")))
                                    }
                                    .resizable()
                                    .progressViewStyle(.linear)
                                    .scaledToFill()                                
                            }
                            .task {
                                if imageURL == viewModel.images.last {
                                    print("End of scroll")
                                    viewModel.loadMoreImagesIfNeeded(currentItemIndex: viewModel.images.count - 1)
                                }
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Images")
        .blur(radius: blurRadius)
        .onChange(of: scenePhase) { newPhase in
            switch newPhase {
            case .active: withAnimation {
                blurRadius = 0
                    withAnimation(.spring()) {
                        appRootManager.currentRoot = .home
                    }
            }
            case .inactive: withAnimation {
                blurRadius = 15
            }
            case .background:
                blurRadius = 20
            @unknown default: print("Unknown")
            }
        }
    }
}

struct FullScreenView: View {
    @ObservedObject var viewModel: MainViewModel
    let imageURL: URL
    @EnvironmentObject private var appRootManager: AppRootManager
    @Environment(\.scenePhase) var scenePhase
    @State var blurRadius : CGFloat = 0
    
    @State private var currentImageIndex: Int
    
    init(viewModel: MainViewModel, imageURL: URL) {
        self.viewModel = viewModel
        self.imageURL = imageURL
        _currentImageIndex = State(initialValue: viewModel.images.firstIndex(of: imageURL) ?? 0)
    }
    
    var body: some View {
        KFImage(viewModel.images[currentImageIndex])
            .resizable()
            .scaledToFit()
            .gesture(
                DragGesture()
                    .onEnded { value in
                        if value.translation.width < 0 {
                            swipeLeft()
                        } else if value.translation.width > 0 {
                            swipeRight()
                        }
                    }
            )
            .blur(radius: blurRadius)
            .onChange(of: scenePhase) { newPhase in
                switch newPhase {
                case .active: withAnimation {
                    blurRadius = 0
                        withAnimation(.spring()) {
                            appRootManager.currentRoot = .home
                        }
                }
                case .inactive: withAnimation {
                    blurRadius = 15
                }
                case .background:
                    blurRadius = 20
                @unknown default: print("Unknown")
                }
            }
    }
    
    func swipeLeft() {
        if currentImageIndex < viewModel.images.count - 1 {
            currentImageIndex += 1
        }
    }
    
    func swipeRight() {
        if currentImageIndex > 0 {
            currentImageIndex -= 1
        }
    }
}
