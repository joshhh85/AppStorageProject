//
//  ABCView.swift
//  AppStorageProject
//
//
import SwiftUI
import ComposableArchitecture

struct ABCView: View {
    let store: StoreOf<ABCFeature>

    var body: some View {
        WithViewStore(self.store, observe: { $0 }, content: { viewStore in
            NavigationStack {
                VStack {
                    Text(String(String(viewStore.state.switchValue))).foregroundStyle(.yellow)

                }
            }
        })
    }
}

struct ABCFeature: Reducer {
    struct State: Equatable {
        @BindingState var switchValue: Bool = false
    }
    
    enum Action: Equatable, BindableAction {
        case binding(BindingAction<State>)
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer()

        .onChange(of: \.switchValue) { oldValue, newValue in
            Reduce { state, _ in
                print(String(state.switchValue))
                return .none
            }
        }
    }
}
