//
//  DownloadFeature.swift
//  RetryTCA
//
//  Created by Bellum on 04/08/2023.
//

import ComposableArchitecture

enum NetworkError: Error {
    case unknownError
}

// 3 different APIs
@Sendable func downloadBool() async throws -> Bool {
    try await Task.sleep(for: .seconds(1))
    if .random(in: 0...1) > 0.25 {
        throw NetworkError.unknownError
    }
    return Bool.random()
}

@Sendable func downloadInt() async throws -> Int {
    try await Task.sleep(for: .seconds(1))
    if .random(in: 0...1) > 0.25 {
        throw NetworkError.unknownError
    }
    return .random(in: 0...10)
}

@Sendable func downloadString() async throws -> String {
    try await Task.sleep(for: .seconds(1))
    if .random(in: 0...1) > 0.25 {
        throw NetworkError.unknownError
    }
    return "String\(Int.random(in: 10...20))"
}

struct DownloadFeature: Reducer {
    struct State: Equatable {
        var boolDownloadInProgress: Bool = false
        var boolDownloadDidFail: Bool = false
        var boolDownloadResponse: Bool?

        var intDownloadInProgress: Bool = false
        var intDownloadDidFail: Bool = false
        var intDownloadResponse: Int?

        var stringDownloadInProgress: Bool = false
        var stringDownloadDidFail: Bool = false
        var stringDownloadResponse: String?

        // child
        var boolDownloadRetry: RequestRetryFeature<Bool>.State {
            get { .init(requestDidFail: boolDownloadDidFail, requestInProgress: boolDownloadInProgress) }
            set { (self.boolDownloadDidFail, self.boolDownloadInProgress) = (newValue.requestDidFail, newValue.requestInProgress) }
        }
        var intDownloadRetry: RequestRetryFeature<Int>.State {
            get { .init(requestDidFail: intDownloadDidFail, requestInProgress: intDownloadInProgress) }
            set { (self.intDownloadDidFail, self.intDownloadInProgress) = (newValue.requestDidFail, newValue.requestInProgress) }
        }
        var stringDownloadRetry: RequestRetryFeature<String>.State {
            get { .init(requestDidFail: stringDownloadDidFail, requestInProgress: stringDownloadInProgress) }
            set { (self.stringDownloadDidFail, self.stringDownloadInProgress) = (newValue.requestDidFail, newValue.requestInProgress) }
        }
    }

    enum Action: Equatable {
        case didTapDownloadBool
        case didTapDownloadInt
        case didTapDownloadString

        // child
        case retryRequestBoolFeature(RequestRetryFeature<Bool>.Action)
        case retryRequestIntFeature(RequestRetryFeature<Int>.Action)
        case retryRequestStringFeature(RequestRetryFeature<String>.Action)
    }

    var body: some Reducer<State, Action> {
        Scope(state: \.boolDownloadRetry, action: /Action.retryRequestBoolFeature) {
            RequestRetryFeature(request: downloadBool)
        }
        Scope(state: \.intDownloadRetry, action: /Action.retryRequestIntFeature) {
            RequestRetryFeature(request: downloadInt)
        }
        Scope(state: \.stringDownloadRetry, action: /Action.retryRequestStringFeature) {
            RequestRetryFeature(request: downloadString)
        }
        Reduce { state, action in
            switch action {
            // Bool
            case .didTapDownloadBool:
                return .send(.retryRequestBoolFeature(.sendRequest))

            case .retryRequestBoolFeature(.response(.success(let response))):
                state.boolDownloadResponse = response
                return .none

            case .retryRequestBoolFeature(.response(.failure)):
                state.boolDownloadResponse = nil
                return .none
                
            case .retryRequestBoolFeature:
                return .none

            // Int
            case .didTapDownloadInt:
                return .send(.retryRequestIntFeature(.sendRequest))

            case .retryRequestIntFeature(.response(.success(let response))):
                state.intDownloadResponse = response
                return .none

            case .retryRequestIntFeature(.response(.failure)):
                state.intDownloadResponse = nil
                return .none

            case .retryRequestIntFeature:
                return .none

            // String
            case .didTapDownloadString:
                return .send(.retryRequestStringFeature(.sendRequest))

            case .retryRequestStringFeature(.response(.success(let response))):
                state.stringDownloadResponse = response
                return .none

            case .retryRequestStringFeature(.response(.failure)):
                state.stringDownloadResponse = nil
                return .none

            case .retryRequestStringFeature:
                return .none
            }
        }
    }
}
