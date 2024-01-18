//
//  ContentView.swift
//  AppStorageProject
//
//

import SwiftUI
import ComposableArchitecture

struct ContentView: View {
    let store: StoreOf<ContentFeature>

    var body: some View {
        WithViewStore(self.store, observe: { $0 }, content: { viewStore in
            NavigationStack {
                VStack {
                    Text(String(String(viewStore.state.switchValue)))
                    ABCView(store: store.scope(state: \.abcState, action: ContentFeature.Action.abcAction))
                }

                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        Button(action: {
                            viewStore.send(.settingsButtonTapped)
                        }, label: {
                            Image(systemName: "gear")
                        })
                        
                        .popover(
                            store: self.store.scope(state: \.$destination, action: { .destination($0) }),
                            state: /ContentFeature.Destination.State.settings,
                            action: ContentFeature.Destination.Action.settings,
                            attachmentAnchor: .point(.top),
                            arrowEdge: .bottom ) { store in
                                SettingsView(store: store )
                            }
                    }
                }
            }
        })
    }
}

struct ContentFeature: Reducer {
    public struct Destination: Reducer {
        public enum State: Equatable {
            case settings(SettingsFeature.State)
        }
        
        public enum Action: Equatable {
            case settings(SettingsFeature.Action)
        }
        
        public var body: some ReducerOf<Self> {
            Scope(state: /State.settings, action: /Action.settings) { SettingsFeature() }

        }
    }
    
    struct State: Equatable {
        @PresentationState public var destination: Destination.State?
        var settingState: SettingsFeature.State
        var abcState: ABCFeature.State
        @BindingState var switchValue = ""

        init() {
            self.settingState = SettingsFeature.State()
            self.abcState = ABCFeature.State()
        }
    }
    
    enum Action: Equatable, BindableAction {
        case settingsButtonTapped
        case destination(PresentationAction<Destination.Action>)
        case settingAction(SettingsFeature.Action)
        case abcAction(ABCFeature.Action)
        case binding(BindingAction<State>)
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.settingState, action: /Action.settingAction) { SettingsFeature() }
        Scope(state: \.abcState, action: /Action.abcAction) { ABCFeature() }
        BindingReducer()
                
                Reduce { state, action in
                    switch action {
                    case .settingsButtonTapped:
                        state.destination = .settings(SettingsFeature.State())
                        return .none
                        
                    case .destination(.presented(.settings(.settingsChanged(let value)))):
                        print(String(value))
                        state.switchValue = String(value)
                        state.abcState.switchValue = value
                        return .none
                        
                    case .settingAction:
                        return .none
                    case .destination(.dismiss):
                        return .none
                        
                    case .abcAction:
                        return .none
                    case .binding:
                        return .none
                    }
                }
        
                .onChange(of: \.switchValue) { oldValue, newValue in
                    Reduce { state, _ in
                        print(String(state.settingState.settingsToggle))
                        return .none
                    }
                }
                .ifLet(\.$destination, action: /Action.destination) { Destination() }
    }
}


#Preview {
    ContentView(
        store: Store(initialState: ContentFeature.State()) {
            ContentFeature()
        }
    )
}

extension UserDefaults {
    var settingsToggle: Bool {
        get { self.bool(forKey: "settingsToggle") }
        set { set(newValue, forKey: "settingsToggle") }
    }
}
