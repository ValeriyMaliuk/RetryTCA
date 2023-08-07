//
//  ContentView.swift
//  RetryTCA
//
//  Created by Bellum on 04/08/2023.
//

import SwiftUI
import ComposableArchitecture

struct DownloadView: View {
    let store: StoreOf<DownloadFeature>

    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            ZStack(alignment: .bottom) {
                VStack {
                    Spacer()

                    HStack {
                        Button("Download Bool") {
                            viewStore.send(.didTapDownloadBool)
                        }

                        if viewStore.boolDownloadInProgress {
                            ProgressView()
                        }

                        if let response = viewStore.boolDownloadResponse {
                            Text("Response:\(response.description)")
                        }
                    }
                    .padding()

                    HStack {
                        Button("Download Int") {
                            viewStore.send(.didTapDownloadInt)
                        }

                        if viewStore.intDownloadInProgress {
                            ProgressView()
                        }

                        if let response = viewStore.intDownloadResponse {
                            Text("Response:\(response)")
                        }
                    }
                    .padding()

                    HStack {
                        Button("Download String") {
                            viewStore.send(.didTapDownloadString)
                        }

                        if viewStore.stringDownloadInProgress {
                            ProgressView()
                        }

                        if let response = viewStore.stringDownloadResponse {
                            Text("Response:\(response)")
                        }
                    }
                    .padding()

                    Spacer()
                }
                .padding()

                VStack {
                    if viewStore.boolDownloadDidFail {
                        RetryView(store: store.scope(
                            state: \.boolDownloadRetry,
                            action: DownloadFeature.Action.retryRequestBoolFeature
                        ))
                    }
                    
                    if viewStore.intDownloadDidFail {
                        RetryView(store: store.scope(
                            state: \.intDownloadRetry,
                            action: DownloadFeature.Action.retryRequestIntFeature
                        ))
                    }
                    
                    if viewStore.stringDownloadDidFail {
                        RetryView(store: store.scope(
                            state: \.stringDownloadRetry,
                            action: DownloadFeature.Action.retryRequestStringFeature
                        ))
                    }
                }
            }
        }
    }
}

struct DownloadView_Previews: PreviewProvider {
    static var previews: some View {
        DownloadView(
            store: Store(initialState: .init()) {
                DownloadFeature()
            }
        )
    }
}
