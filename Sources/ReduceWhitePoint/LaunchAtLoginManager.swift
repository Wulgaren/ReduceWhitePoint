import AppKit
import ServiceManagement

class LaunchAtLoginManager {
    static let shared = LaunchAtLoginManager()
    
    private let bundleIdentifier = "com.reducewhitepoint.app"
    
    private init() {}
    
    var isEnabled: Bool {
        get {
            // Check if app is in Login Items
            guard let loginItems = SMCopyAllJobDictionaries(kSMDomainUserLaunchd).takeRetainedValue() as? [[String: Any]] else {
                return false
            }
            
            let bundleURL = Bundle.main.bundleURL
            for item in loginItems {
                if let itemURL = item["ProgramArguments"] as? [String],
                   let firstArg = itemURL.first,
                   URL(fileURLWithPath: firstArg) == bundleURL {
                    return true
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
        
        // Get the app's bundle identifier
        if let bundleID = Bundle.main.bundleIdentifier {
            // Register the app
            LSRegisterURL(bundleURL, true)
            
            // Add to Login Items using AppleScript (most reliable)
            addToLoginItems()
        }
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
