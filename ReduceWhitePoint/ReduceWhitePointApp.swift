import SwiftUI
import AppKit

@main
struct ReduceWhitePointApp: App {
    @StateObject private var whitePointManager = WhitePointManager.shared
    
    var body: some Scene {
        MenuBarExtra("Reduce White Point", systemImage: "moon.stars") {
            MenuBarView()
        }
        .menuBarExtraStyle(.window)
    }
}

struct MenuBarView: View {
    @StateObject private var whitePointManager = WhitePointManager.shared
    @State private var intensity: Double = UserDefaults.standard.double(forKey: "whitePointIntensity")
    @State private var launchAtLogin: Bool = LaunchAtLoginManager.shared.isEnabled
    
    var body: some View {
        VStack(spacing: 12) {
            Text("Reduce White Point")
                .font(.headline)
                .padding(.top)
            
            Toggle("Enabled", isOn: Binding(
                get: { whitePointManager.isEnabled },
                set: { newValue in
                    whitePointManager.setEnabled(newValue)
                }
            ))
            .padding(.horizontal)
            
            if whitePointManager.isEnabled {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Intensity: \(Int(intensity))%")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Slider(value: $intensity, in: 0...100, step: 1) { _ in
                        whitePointManager.setIntensity(intensity)
                    }
                    .padding(.horizontal)
                }
            }
            
            Divider()
            
            Toggle("Launch at Login", isOn: Binding(
                get: { launchAtLogin },
                set: { newValue in
                    launchAtLogin = newValue
                    LaunchAtLoginManager.shared.setEnabled(newValue)
                }
            ))
            .padding(.horizontal)
            
            Divider()
            
            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }
            .padding(.bottom)
        }
        .frame(width: 250)
        .padding()
        .onAppear {
            intensity = whitePointManager.intensity
            launchAtLogin = LaunchAtLoginManager.shared.isEnabled
        }
    }
}
