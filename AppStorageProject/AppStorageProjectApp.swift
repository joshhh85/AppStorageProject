//
//  AppStorageProjectApp.swift
//  AppStorageProject
//
//

import SwiftUI
import ComposableArchitecture

@main
struct AppStorageProjectApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(store: Store(initialState: ContentFeature.State()) {
                ContentFeature()
            })
        }
    }
}
