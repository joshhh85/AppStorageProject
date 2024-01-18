//
//  SettingsView.swift
//  AppStorageProject
//

//

import SwiftUI
import ComposableArchitecture

struct SettingsView: View {
    let store: StoreOf<SettingsFeature>
    
    @AppStorage("settingsToggle") var settingsToggle = true
    var body: some View {
        WithViewStore(self.store, observe: { $0 }, content: { viewStore in
            List {
                Section(header: Text("Downloads")) {
                    Toggle("Toggle value",
                              isOn: viewStore.binding(
                                get: \.settingsToggle,
                                send: { .settingsChanged($0)}))
                }
            }
            .frame(minWidth: 500, minHeight: 300)
        })
    }
}

struct SettingsFeature: Reducer {
    struct State: Equatable {
        var settingsToggle: Bool = false
    }
    public enum Action: Equatable { 
     case settingsChanged(Bool)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .settingsChanged(let value):
                state.settingsToggle = value
                UserDefaults.standard.settingsToggle = value
                return .none
            }
        }
    }
}
