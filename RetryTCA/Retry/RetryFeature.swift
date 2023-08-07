//
//  RetryFeature.swift
//  RetryTCA
//
//  Created by Bellum on 04/08/2023.
//

import Foundation
import ComposableArchitecture
import SwiftUI

struct RequestRetryFeature<T: Equatable>: Reducer {
    let request: @Sendable () async throws -> T

    struct State: Equatable {
        var requestDidFail = false
        var requestInProgress = false
    }

    enum Action: Equatable {
        case retry
        case sendRequest
        case response(TaskResult<T>)
    }

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .retry:
                return sendRequest(state: &state)

            case .sendRequest:
                return sendRequest(state: &state)

            case .response(.failure):
                state.requestDidFail = true
                state.requestInProgress = false
                return .none

            case .response(.success):
                state.requestDidFail = false
                state.requestInProgress = false
                return .none
            }
        }
    }

    func sendRequest(state: inout State) -> Effect<Action> {
        state.requestDidFail = false
        state.requestInProgress = true
        return .run { send in
            await send(.response(TaskResult { try await request() }))
        }
    }
}

struct RetryView<T: Equatable>: View {
    let store: StoreOf<RequestRetryFeature<T>>

    var body: some View {
        VStack {
            Text("Unfortunately your request has failed")
                .padding()

            Button("Retry") {
                store.send(.retry)
            }
            .padding()
        }
        .padding()
        .background(Color.red.opacity(0.8))
        .clipShape(RoundedRectangle(cornerRadius: 15))
    }
}
