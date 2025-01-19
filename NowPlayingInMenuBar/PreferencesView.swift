//
//  PreferencesView.swift
//  NowPlayingInMenuBar
//

import SwiftUI
import AppKit
import ServiceManagement

struct PreferencesView: View {
    
    @State var launchAtLogin: Bool = SMAppService.mainApp.status == .enabled
    
    var body: some View {
        VStack {
            Toggle("Launch at login", isOn: $launchAtLogin)
                .toggleStyle(.checkbox)
                .padding()
        }
    }
}

#Preview {
    PreferencesView()
}

struct PreferencesViewController: NSViewControllerRepresentable {
    func makeNSViewController(context: Context) -> some NSViewController {
        let controller = NSHostingController(rootView: PreferencesView())
        return controller
    }
    
    func updateNSViewController(_ nsViewController: NSViewControllerType, context: Context) {
        
    }
}
