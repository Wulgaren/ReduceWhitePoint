import AppKit
import ServiceManagement

class LaunchAtLoginManager {
    static let shared = LaunchAtLoginManager()
    
    private let bundleIdentifier = "com.reducewhitepoint.app"
    
    private init() {}
    
    var isEnabled: Bool {
        get {
            // Check if app is in Login Items using AppleScript (more reliable)
            let script = """
            tell application "System Events"
                get the name of every login item
            end tell
            """
            
            if let appleScript = NSAppleScript(source: script) {
                var error: NSDictionary?
                if let result = appleScript.executeAndReturnError(&error), error == nil {
                    if let loginItems = result.stringValue {
                        let appName = Bundle.main.bundleURL.lastPathComponent
                        return loginItems.contains(appName)
                    }
                }
            }
            return false
        }
    }
    
    func setEnabled(_ enabled: Bool) {
        if enabled {
            enableLaunchAtLogin()
        } else {
            disableLaunchAtLogin()
        }
    }
    
    private func enableLaunchAtLogin() {
        // Use SMLoginItemSetEnabled for modern approach
        // But first, we need to create a helper app or use the app itself
        
        // Alternative: Use LSRegisterURL and add to Login Items
        let bundleURL = Bundle.main.bundleURL as CFURL
        
        // Register the app
        LSRegisterURL(bundleURL, true)
        
        // Add to Login Items using AppleScript (most reliable)
        addToLoginItems()
    }
    
    private func disableLaunchAtLogin() {
        removeFromLoginItems()
    }
    
    private func addToLoginItems() {
        let script = """
        tell application "System Events"
            make login item at end with properties {path:"\(Bundle.main.bundlePath)", hidden:false}
        end tell
        """
        
        if let appleScript = NSAppleScript(source: script) {
            var error: NSDictionary?
            _ = appleScript.executeAndReturnError(&error)
            if let error = error {
                print("Error adding to login items: \(error)")
            }
        }
    }
    
    private func removeFromLoginItems() {
        let bundlePath = Bundle.main.bundlePath
        let script = """
        tell application "System Events"
            delete login item "\(bundlePath)"
        end tell
        """
        
        if let appleScript = NSAppleScript(source: script) {
            var error: NSDictionary?
            _ = appleScript.executeAndReturnError(&error)
            if let error = error {
                print("Error removing from login items: \(error)")
            }
        }
    }
}
