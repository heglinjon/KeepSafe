{\rtf1\ansi\ansicpg1252\cocoartf2639
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\fswiss\fcharset0 Helvetica;\f1\fnil\fcharset0 .AppleSystemUIFontMonospaced-Regular;\f2\fnil\fcharset0 LucidaGrande;
}
{\colortbl;\red255\green255\blue255;\red224\green232\blue240;}
{\*\expandedcolortbl;;\cssrgb\c90196\c92941\c95294;}
\margl1440\margr1440\vieww17640\viewh12620\viewkind0
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0

\f0\fs24 \cf0 # Building and Running the Application\
\
This document provides instructions on how to build and run the application. Please follow the steps below:\
\
## Prerequisites\
\
Before proceeding, ensure that you have the following software installed on your system:\
\
- Xcode (version 12 or later)\
- Swift (version 5 or later)\
\
## Clone the Repository\
\
1. Open a terminal window.\
2. Change to the directory where you want to clone the repository.\
3. Run the following command to clone the repository:\
\
```\
git clone 
\f1\fs28 \cf2 \expnd0\expndtw0\kerning0
\outl0\strokewidth0 \strokec2 https://github.com/heglinjon/KeepSafe.git\

\f0\fs24 \cf0 \kerning1\expnd0\expndtw0 \outl0\strokewidth0 \
```\
\
## Build and Run the Application\
\
1. Open the project in Xcode by double-clicking the `.xcworkspace` file.\
2. Select the target device or simulator from the Xcode toolbar.\
3. Click the "Build" button or press 
\f2 \uc0\u8984 
\f0 +B to build the project.\
4. Once the build is successful, click the "Run" button or press 
\f2 \uc0\u8984 
\f0 +R to run the application on the selected device or simulator.\
\
Note: If you encounter any build errors, make sure to resolve them before proceeding.\
\
## Testing the Application\
\
To run the tests for the application, follow these steps:\
\
1. In Xcode, select the scheme for the application.\
2. Click the "Test" button or press 
\f2 \uc0\u8984 
\f0 +U to run the tests.\
3. Xcode will display the test results in the test navigator and the console.\
\
\
\
The given code represents a mini KeepSafe Application. The app has two main screens: a PIN screen and a content screen for displaying images.\
\
Design Pattern:\
The code follows patterns in iOS development, such as the Model-View-ViewModel (MVVM) pattern and the ObservableObject pattern.\
\
1. Model-View-ViewModel (MVVM) Pattern:\
The MVVM pattern is observed in the code through the separation of concerns into distinct components:\
\
- Models: The `ImageModel` struct represents the model for the image data fetched from the API.\
- Views: The various SwiftUI views (`PinScreenView`, `ContentView`, `FullScreenView`) represent the visual presentation of the app's screens.\
- ViewModels: The `MainViewModel` class acts as the ViewModel, responsible for managing the app's data and business logic. It interacts with the `ImageAPIService` to fetch images and updates the `images` property, which is observed by the views.\
\
The MVVM pattern promotes separation of concerns by decoupling the views from the underlying data and business logic. Views bind to ViewModel properties, and any changes to the ViewModel's data automatically update the corresponding views.\
\
2. ObservableObject Pattern( MVVM in SwiftUI):\
The code uses the `ObservableObject` protocol and the `@Published` property wrapper in the `AppRootManager` and `MainViewModel` classes. This pattern enables the views to observe changes to specific properties and update their content accordingly.\
\
- The `AppRootManager` class is an ObservableObject that manages the current root state of the app. The `currentRoot` property is marked with `@Published`, allowing views that use `@EnvironmentObject` to automatically update when this property changes.\
- The `MainViewModel` class is also an ObservableObject, and the `images` and `currentIndex` properties are marked with `@Published`. Any changes to these properties will trigger updates in the views observing them.\
\
Other Aspects of the Project:\
1. PersistenceService Protocol and KeychainPersistenceService:\
- The `PersistenceService` protocol defines a contract for saving and reading data.\
- The `KeychainPersistenceService` class conforms to the `PersistenceService` protocol and provides an implementation using the Keychain API for securely saving and retrieving data.\
\
2. ImageAPIService and ImageAPIServiceImpl:\
- The `ImageAPIService` protocol defines a contract for fetching images from a remote API.\
- The `ImageAPIServiceImpl` class implements the `ImageAPIService` protocol. It uses URLSession to fetch images from the provided URL and decode them using JSONDecoder.\
\
3. PinScreenView:\
- The `PinScreenView` struct represents the PIN screen where users enter their PIN to access the app.\
- It interacts with the `AppRootManager` to update the `currentRoot` property when the correct PIN is entered, transitioning the app to the content screen.\
- It also utilizes the `PersistenceService` (specifically `KeychainPersistenceService`) to save and read the PIN.\
\
4. ContentView and FullScreenView:\
- The `ContentView` struct represents the content screen that displays a grid of images.\
- It utilizes the `MainViewModel` to fetch images, manage the current index, and load more images when scrolling.\
- The `FullScreenView` struct represents a full-screen view for displaying individual images.\
- It also uses the `MainViewModel` to manage the current image index and supports swiping left and right to navigate between images.\
\
These are some of the design patterns and aspects of the given project. The code demonstrates the use of SwiftUI and KingFisher framework to create an app with a PIN screen and an image content screen.\
\
\
\
Thank you for reviewing the application. If you have any further questions or need assistance, please don't hesitate to reach out.}