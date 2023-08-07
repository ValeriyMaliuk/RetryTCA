//
//  RetryTCAApp.swift
//  RetryTCA
//
//  Created by Bellum on 04/08/2023.
//

import SwiftUI
import ComposableArchitecture

@main
struct RetryTCAApp: App {
    var body: some Scene {
        WindowGroup {
            DownloadView(store: Store(initialState: .init(), reducer: {
                DownloadFeature()
                    ._printChanges()
            }))
        }
    }
}
